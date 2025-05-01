import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

/// 下载任务状态
class TaskStatus {
  static const String pending = 'pending';
  static const String completed = 'completed';
  static const String error = 'error';
  static const String fail = 'fail';
  static const String mergeVideos = 'merge videos';
  static const String inProgress = 'inProgress';
  static const String cancelled = 'cancelled';
}

class DownloadTaskList {
  final String url;
  late int id;
  late String title;
  late String thumbnail;
  late Uint8List thumb;
  late String _status;
  late String _displayStatus;
  late String key;
  late String duration;
  late String log;
  late int filesize;
  Process? process;

  String get status => _status;
  String get displayStatus => _displayStatus;

  void _updateDisplayStatus() {
    switch (_status) {
      case TaskStatus.pending:
        _displayStatus = '读取中...';
        break;
      case TaskStatus.completed:
        _displayStatus = '下载完成';
        break;
      case TaskStatus.error:
        _displayStatus = '下载出错';
        break;
      case TaskStatus.fail:
        _displayStatus = '下载失败';
        break;
      case TaskStatus.mergeVideos:
        _displayStatus = '正在合并视频...';
        break;
      case TaskStatus.inProgress:
        _displayStatus = '下载中...';
        break;
      case TaskStatus.cancelled:
        _displayStatus = '已取消';
        break;
      default:
        _displayStatus = _status; // 如果是动态进度信息，直接显示
    }
  }

  set status(String newStatus) {
    _status = newStatus;
    _updateDisplayStatus();
  }

  DownloadTaskList(
    this.url, {
    int id = 0,
    String key = "",
    String duration = '',
    String thumbnail = '',
    String title = '',
    String status = TaskStatus.pending,
    String log = "",
    int filesize = 0,
  }) {
    this.id = id;
    this.log = log;
    _status = status;
    this.title = title;
    this.thumbnail = thumbnail;
    this.duration = duration;
    this.key = key;
    this.filesize = filesize;
    this.thumb = Uint8List(0);
    _updateDisplayStatus();
  }

  void cancel() async {
    if (process != null) {
      final pid = process!.pid;
      if (Platform.isWindows) {
        try {
          // 终止进程树
          await Process.run('taskkill', ['/F', '/T', '/PID', pid.toString()]);
          // 等待并获取最终状态
          await Future.delayed(Duration(milliseconds: 500));
          int? code = await process?.exitCode;
          debugPrint("Exit code: $code");
        } catch (e) {
          debugPrint("终止失败: $e");
        }
      } else {
        process?.kill();
        int? code = await process?.exitCode;
        debugPrint("Exit code: $code");
      }

      status = TaskStatus.cancelled;
    }
  }

  @override
  String toString() {
    return 'DownloadTaskList:$key:$title:$duration,$status';
  }
}
