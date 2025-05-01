import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ardl/gen/assets.gen.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DownloadTools {
  String ytDlpPath = "";
  String ffmpegPath = "";
  String ffprobePath = "";

  Future<void> initializeArdl({
    required void Function(double progress) onProgress,
  }) async {
    try {
      final directory = await getApplicationSupportDirectory();
      if (Platform.isMacOS || Platform.isLinux) {
        ytDlpPath = p.join(directory.path, 'yt-dlp');
      } else {
        ytDlpPath = p.join(directory.path, 'yt-dlp.exe');
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final fileExists = await File(ytDlpPath).exists();
      if (!fileExists) {
        onProgress(0);
      }
      // 检查更新
      bool needsUpdate = false;

      // try {
      //   needsUpdate = await _checkForUpdate(
      //       Platform.isMacOS || Platform.isLinux
      //           ? 'https://wowyou.cc/yt-dlp'
      //           : 'https://wowyou.cc/yt-dlp.exe',
      //       ytDlpPath);
      // } catch (e) {
      //   debugPrint('检查更新失败: $e');
      //   // 如果检查更新失败，但文件存在，我们继续使用现有文件
      //   if (fileExists) {
      //     onProgress(100);
      //     return;
      //   }
      //   // 如果文件不存在，我们需要继续尝试下载
      //   needsUpdate = true;
      // }

      debugPrint('initializeArdl:ytDlpPath:$ytDlpPath');
      // if (!fileExists || needsUpdate) {
      if (false) {
        try {
          if (Platform.isMacOS || Platform.isLinux) {
            await downloadFile('https://wowyou.cc/yt-dlp', ytDlpPath,
                onProgress: onProgress);
          } else {
            await downloadFile('https://wowyou.cc/yt-dlp.exe', ytDlpPath,
                onProgress: onProgress);
          }

          if (Platform.isMacOS || Platform.isLinux) {
            final result = await Process.run('chmod', ['+x', ytDlpPath]);
            if (result.exitCode != 0) {
              throw Exception(
                  'Failed to set executable permission: ${result.stderr}');
            }
          }
          // 更新本地版本信息
          await _saveVersionInfo(ytDlpPath);
        } catch (downloadError) {
          debugPrint('下载失败: $downloadError');
          // 如果下载失败但文件已存在，我们继续使用现有文件
          if (fileExists) {
            onProgress(100);
            return;
          }
          // 如果文件不存在，则抛出异常
          rethrow;
        }
      } else {
        onProgress(100);
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
      onProgress(-1);
      rethrow;
    }
  }

  // 检查服务器文件是否有更新
  Future<bool> _checkForUpdate(String url, String localFilePath) async {
    try {
      // 获取本地版本信息
      final versionFile = File('${localFilePath}.version');

      if (!await versionFile.exists()) {
        debugPrint('版本文件不存在，需要更新');
        return true; // 没有版本信息，需要更新
      }

      final localVersion = await versionFile.readAsString();
      // 添加超时和重试机制
      int maxRetries = 3;
      int currentRetry = 0;
      while (currentRetry < maxRetries) {
        try {
          final client = http.Client();
          final request = http.Request('HEAD', Uri.parse(url));
          final response = await client.send(request).timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('请求超时');
            },
          );

          debugPrint('服务器响应状态码: ${response.statusCode}');
          if (response.statusCode != 200) {
            debugPrint('无法获取服务器信息，使用本地文件');
            return false;
          }

          final headers = response.headers;
          final serverVersion = headers['last-modified'] ??
              headers['etag'] ??
              DateTime.now().toIso8601String();
          debugPrint('服务器版本: $serverVersion');

          final needsUpdate = serverVersion != localVersion;
          debugPrint('是否需要更新: $needsUpdate');
          return needsUpdate;
        } catch (e) {
          currentRetry++;
          if (currentRetry >= maxRetries) {
            debugPrint('重试${maxRetries}次后仍然失败，使用本地文件');
            return false;
          }
          debugPrint('第${currentRetry}次重试检查更新');
          await Future.delayed(Duration(seconds: 1)); // 重试前等待1秒
        }
      }
      return false;
    } catch (e, stackTrace) {
      debugPrint('检查更新失败: $e');
      debugPrint('错误堆栈: $stackTrace');
      return false; // 出错时使用本地文件
    }
  }

  // 保存版本信息到本地
  Future<void> _saveVersionInfo(String localFilePath) async {
    try {
      final url = Platform.isMacOS || Platform.isLinux
          ? 'https://wowyou.cc/yt-dlp'
          : 'https://wowyou.cc/yt-dlp.exe';

      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        final versionInfo = response.headers['last-modified'] ??
            response.headers['etag'] ??
            DateTime.now().toIso8601String();

        await File('${localFilePath}.version').writeAsString(versionInfo);
      }
    } catch (e) {
      debugPrint('保存版本信息失败: $e');
    }
  }

  Future<void> initializeFfmpeg() async {
    try {
      final directory = await getApplicationSupportDirectory();
      if (Platform.isWindows) {
        ffmpegPath = p.join(directory.path, 'ffmpeg.exe');
      } else {
        ffmpegPath = p.join(directory.path, 'ffmpeg');
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      debugPrint('ffmpegPath:${ffmpegPath}');
      if (!await File(ffmpegPath).exists()) {
        if (Platform.isWindows) {
          ByteData data = await rootBundle.load(Assets.ffmpeg);
          List<int> bytes = data.buffer.asUint8List();
          await File(ffmpegPath).writeAsBytes(bytes);
        } else {
          ByteData data = await rootBundle.load(Assets.ffmpeg);
          List<int> bytes = data.buffer.asUint8List();
          await File(ffmpegPath).writeAsBytes(bytes);
        }

        if (!Platform.isWindows) {
          final result = await Process.run('chmod', ['+x', ffmpegPath]);
          if (result.exitCode != 0) {
            throw Exception(
                'Failed to set executable permission: ${result.stderr}');
          }
        }
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
    }
  }

  Future<void> downloadFile(
    String url,
    String savePath, {
    required void Function(double progress) onProgress,
  }) async {
    try {
      int maxRetries = 3;
      int currentRetry = 0;

      while (currentRetry < maxRetries) {
        try {
          final client = http.Client();
          final request = http.Request('GET', Uri.parse(url));
          final response = await client.send(request).timeout(
            const Duration(seconds: 120),
            onTimeout: () {
              throw TimeoutException('下载超时');
            },
          );

          final contentLength = response.contentLength;

          if (contentLength != null) {
            int downloaded = 0;
            final file = File(savePath);
            final sink = file.openWrite();

            await response.stream.listen(
              (List<int> chunk) {
                downloaded += chunk.length;
                sink.add(chunk);
                String progressStr =
                    (downloaded / contentLength * 100).toStringAsFixed(2);
                double progress = double.parse(progressStr);
                onProgress(progress);
              },
              onDone: () async {
                await sink.close();
                debugPrint('文件已成功下载并保存到 $savePath');
              },
              onError: (e) {
                throw e;
              },
            ).asFuture(); // 等待下载完成

            return; // 下载成功，退出重试循环
          } else {
            throw Exception('无法获取内容长度');
          }
        } catch (e) {
          currentRetry++;
          if (currentRetry >= maxRetries) {
            throw Exception('重试${maxRetries}次后下载仍然失败: $e');
          }
          debugPrint('第${currentRetry}次重试下载');
          await Future.delayed(Duration(seconds: 1));
        }
      }
    } catch (e) {
      debugPrint('下载失败: $e');
      // 通知调用者下载失败
      onProgress(-1);
      rethrow;
    }
  }

  Dio _buildDioWithProxy({String? proxyAddress}) {
    final dio = Dio();
    // 设置代理（根据实际需求配置）
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      if (proxyAddress != null && proxyAddress.isNotEmpty) {
        client.findProxy = (uri) => "PROXY $proxyAddress"; // 替换为你的代理地址
      }
      client.badCertificateCallback = (cert, host, port) => true; // 绕过证书验证（可选）
      return client;
    };
    // 全局超时设置
    dio.options.connectTimeout = Duration(seconds: 20);
    dio.options.receiveTimeout = Duration(seconds: 20);
    return dio;
  }

  Future<Uint8List?> downloadImage(String url, {String? proxyAddress}) async {
    if (url.isEmpty) {
      return null;
    }
    debugPrint('downloadImageUrl:$url,proxyAddress:$proxyAddress');
    try {
      final dio = _buildDioWithProxy(proxyAddress: proxyAddress);
      final response = await dio.get<Uint8List>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data;
    } catch (e) {
      debugPrint('downloadImage失败: $e');
      return null;
    }
  }
}
