import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ardl/utils/download_tools.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../download_task_list.dart';
import '../database/database.dart';
import '../exceptions/app_exceptions.dart';
import '../services/settings_service.dart';
import '../utils/common.dart';

/// 下载服务相关常量
class ArdlServiceConstants {
  static const int defaultOffset = 0;
  static const int defaultLimit = 20;
}

/// 下载服务类
/// 负责处理视频下载相关的所有操作
class ArdlService {
  final AppDatabase db;
  final void Function(void Function()) setState;
  final ISettingsService _settingsService;
  final DownloadTools _downloadTools;

  ArdlService(this.db, this.setState, this._settingsService)
      : _downloadTools = DownloadTools();

  /// 获取下载目录路径
  /// 如果目录不存在则创建
  Future<String> getDownloadDir() async {
    String downloadDirPath = await _settingsService.getDownloadPath();
    if (downloadDirPath.isEmpty) {
      throw Exception("下载目录未设置");
    }

    final downloadDir = Directory(downloadDirPath);
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir.path;
  }

  /// 开始下载任务
  Future<void> startDownload(
      DownloadTaskList task, String ytDlpPath, String ffmpegPath) async {
    try {
      await _validateDownloadRequirements(ytDlpPath, ffmpegPath);
      await _checkNetworkConnection();

      String downloadDirPath = await getDownloadDir();
      List<String> args = await _buildDownloadArguments(ffmpegPath);

      setState(() {
        task.status = TaskStatus.pending;
      });

      // 获取视频信息
      if (task.title.isEmpty) {
        await _getMetaInfo(task, ytDlpPath, args);
      }

      // 下载缩略图
      await _downloadThumbnail(task);

      // 开始下载视频
      await _startDownloadProcess(task, ytDlpPath, downloadDirPath, args);

      await db.updateOrInsertTask(task);
    } catch (e) {
      _handleDownloadError(task, e);
    } finally {
      await db.updateOrInsertTask(task);
    }
  }

  /// 验证下载工具路径
  Future<void> _validateDownloadRequirements(
      String ytDlpPath, String ffmpegPath) async {
    if (ytDlpPath.isEmpty || ffmpegPath.isEmpty) {
      throw DownloadException('工具路径错误');
    }
  }

  /// 检查网络连接
  Future<bool> _checkNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('baidu.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      throw NetworkException('网络连接失败');
    }
  }

  /// 构建下载参数
  Future<List<String>> _buildDownloadArguments(String ffmpegPath) async {
    List<String> args = ['--ffmpeg-location', ffmpegPath];

    final showProxySettings = await _settingsService.getShowProxySettings();
    if (showProxySettings) {
      String proxyAddress = await _settingsService.getProxyAddress();
      if (proxyAddress.isNotEmpty) {
        args.addAll(['--proxy', proxyAddress]);
      }
    }

    return args;
  }

  /// 下载缩略图
  Future<void> _downloadThumbnail(DownloadTaskList task) async {
    if (task.thumbnail.isNotEmpty && task.thumb.isEmpty) {
      final proxyAddress = await _settingsService.getProxyAddress();
      Uint8List? bytes = await _downloadTools.downloadImage(task.thumbnail,
          proxyAddress: proxyAddress);
      if (bytes != null) {
        task.thumb = bytes;
      }
    }
  }

  /// 处理下载错误
  void _handleDownloadError(DownloadTaskList task, dynamic error) {
    task.cancel();
    setState(() {
      task.status = TaskStatus.error;
    });
    task.log = error.toString();
  }

  /// 获取视频元信息
  Future<void> _getMetaInfo(
      DownloadTaskList task, String ytDlpPath, List<String> args) async {
    if (ytDlpPath.isEmpty) {
      throw DownloadException('工具路径错误');
    }

    final completer = Completer<void>();
    final titleCommandArgs = [...args, task.url, '-j'];
    String jsonData = '';
    debugPrint('ytDlpPath:$ytDlpPath');
    debugPrint('args:' + titleCommandArgs.join(' '));
    task.process = await Process.start(ytDlpPath, titleCommandArgs)
      ..exitCode.then((exitCode) async {
        if (exitCode != 0) {
          completer.completeError('解析失败，退出码: $exitCode,如果是国外网站请先配置代理');
        } else {
          try {
            await _parseVideoInfo(jsonData, task);
            completer.complete();
          } catch (e) {
            completer.completeError('解析视频信息失败: $e');
          }
        }
      });

    _setupProcessListeners(task.process!,
        onStdout: (data) => jsonData += data,
        onStderr: (data) => debugPrint('_getMetaInfo:stderr:$data'),
        onError: (error) => completer.completeError('解析出错: $error'));

    return completer.future;
  }

  /// 解析视频信息
  Future<void> _parseVideoInfo(String jsonData, DownloadTaskList task) async {
    final videoInfo = json.decode(jsonData);
    setState(() {
      task.title = videoInfo['title'] ?? '未知标题';
      task.key = videoInfo['id'] ?? '';
      task.duration = (videoInfo['duration'] ?? 0).toString();
      task.filesize = videoInfo['filesize_approx'] ?? 0;
      task.thumbnail = videoInfo['thumbnail'] ?? '';
      task.status = TaskStatus.inProgress;
    });
  }

  /// 设置进程监听器
  void _setupProcessListeners(
    Process process, {
    Function(String)? onStdout,
    Function(String)? onStderr,
    Function(dynamic)? onError,
  }) {
    process.stdout.transform(latin1.decoder).listen(
          onStdout,
          onError: onError,
        );

    process.stderr.transform(latin1.decoder).listen(
          onStderr,
          onError: onError,
        );
  }

  /// 开始下载进程
  Future<void> _startDownloadProcess(DownloadTaskList task, String ytDlpPath,
      String downloadPath, List<String> args) async {
    if (ytDlpPath.isEmpty) {
      throw DownloadException('工具路径错误');
    }

    final commandArgs = [
      ...args,
      task.url,
      '-c',
      '-P',
      downloadPath,
      '--force-overwrites',
    ];

    final completer = Completer<void>();

    task.process = await Process.start(ytDlpPath, commandArgs)
      ..exitCode.then((exitCode) {
        _handleDownloadCompletion(task, exitCode, completer);
      });

    _setupProcessListeners(
      task.process!,
      onStdout: (data) => _handleDownloadProgress(task, data),
      onStderr: (data) => debugPrint('###_startDownloadProcess:stderr:$data'),
      onError: (error) => completer.completeError('下载出错: $error'),
    );

    return completer.future;
  }

  /// 处理下载完成
  void _handleDownloadCompletion(
      DownloadTaskList task, int exitCode, Completer<void> completer) {
    setState(() {
      task.status = exitCode == 0 ? TaskStatus.completed : TaskStatus.fail;
    });

    if (exitCode != 0) {
      String msg = exitCode == -15 || exitCode == 1
          ? '下载失败，手动取消: $exitCode'
          : '下载失败，退出码: $exitCode';
      task.log = msg;
      completer.completeError(msg);
    } else {
      task.log = '下载完成';
      completer.complete();
    }
  }

  /// 处理下载进度
  void _handleDownloadProgress(DownloadTaskList task, String data) {
    final result = parseProgress(data);
    if (result != null) {
      setState(() {
        if (result['percentage'] == 100) {
          task.status = TaskStatus.mergeVideos;
        } else {
          task.status =
              '下载进度: ${result['percentage']}%, 文件大小: ${result['fileSize']}, 下载速度: ${result['speed']},剩余时间：${result['time']}';
        }
      });
    }
  }

  /// 保存下载任务列表
  Future<void> saveDownloadTasks(List<DownloadTaskList> tasks) async {
    await db.clearDownloadTasks();
    for (var task in tasks) {
      await db.updateOrInsertTask(task);
    }
  }

  /// 保存单个下载任务
  Future<int> saveTasks(DownloadTaskList task) async {
    return await db.updateOrInsertTask(task);
  }

  /// 加载历史下载任务
  Future<List<DownloadTaskList>> loadHistoryDownloadTasks({
    int offset = ArdlServiceConstants.defaultOffset,
    int limit = ArdlServiceConstants.defaultLimit,
  }) async {
    final tasks = await db.getDownloadTasks(offset: offset, limit: limit);
    return tasks.map((task) => _mapDatabaseTaskToDownloadTask(task)).toList();
  }

  /// 将数据库任务映射为下载任务对象
  DownloadTaskList _mapDatabaseTaskToDownloadTask(task) {
    return DownloadTaskList(task.url)
      ..id = task.id
      ..key = task.key ?? ''
      ..duration = task.duration ?? ''
      ..thumbnail = task.thumbnail ?? ''
      ..thumb = task.thumb ?? Uint8List(0)
      ..title = task.title ?? ''
      ..status = task.status ?? TaskStatus.pending;
  }

  /// 根据URL删除任务
  Future<void> deleteTaskByUrl(String url) async {
    await db.deleteTaskByUrl(url);
  }

  /// 根据ID删除任务
  Future<void> deleteTaskById(int id) async {
    await db.deleteTaskById(id);
  }
}
