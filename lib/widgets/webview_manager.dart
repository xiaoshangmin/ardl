import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart' as p;
import '../utils/common.dart';
import '../utils/flutter_toast.dart';

class DesktopWebView extends StatefulWidget {
  final String url;
  final Function(String, String, int) onCookiesReceived;

  const DesktopWebView({
    super.key,
    required this.url,
    required this.onCookiesReceived,
  });

  @override
  State<DesktopWebView> createState() => _DesktopWebViewState();
}

class _DesktopWebViewState extends State<DesktopWebView> {
  InAppWebViewController? webViewController;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _initializeWindow();
  }

  Future<void> _initializeWindow() async {
    // 设置窗口最小尺寸
    await windowManager.setMinimumSize(const Size(1000, 800));
    await windowManager.setTitle('ardl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url),
        actions: [
          // 刷新按钮
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => webViewController?.reload(),
          ),
          // 获取Cookie按钮
          IconButton(
            icon: const Icon(Icons.cookie),
            onPressed: _getCookies,
          ),
        ],
        // 显示加载进度条
        bottom: progress < 1.0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: LinearProgressIndicator(value: progress),
              )
            : null,
      ),
      body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialSettings: InAppWebViewSettings(
            useHybridComposition: true,
            javaScriptEnabled: true,
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStop: (controller, url) async {
            // await _getCookies();
            // DesktopCookieManager.printCookies(widget.url);
          },
          onProgressChanged: (controller, progress) {
            setState(() {
              this.progress = progress / 100;
            });
          },
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            // 处理证书信任逻辑
            // 这里直接信任证书（仅用于测试，生产环境需谨慎）
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          }),
    );
  }

  Future<void> _getCookies() async {
    try {
      final cookieManager = CookieManager.instance();
      final cookies = await cookieManager.getCookies(url: WebUri(widget.url));
      String siteName = getSiteName(widget.url);
      final path = await CookieExporter.saveCookiesForArdl(cookies, siteName);
      if (mounted) {
        showToast(context, '保存 Cookie 成功');
      }
      // 计算过期时间戳
      int expiryTimestamp = 0;
      if (cookies.isNotEmpty) {
        expiryTimestamp = (cookies.first.expiresDate != null
            ? cookies.first.expiresDate!
            : 0);
      }
      widget.onCookiesReceived(path, siteName, expiryTimestamp);
    } catch (e) {
      if (mounted) {
        showToastWithButton(context, '保存 Cookie 失败', '知道了', () => {});
      }
      debugPrint('获取 Cookie 失败: $e');
    }
  }
}

// Cookie 管理工具类
class DesktopCookieManager {
  static final cookieManager = CookieManager.instance();

  // 获取指定网站的所有 cookies
  static Future<List<Cookie>> getCookies(String url) async {
    return await cookieManager.getCookies(url: WebUri(url));
  }

  // 设置 cookie
  static Future<void> setCookie({
    required String url,
    required String name,
    required String value,
    String? domain,
    String? path = "/",
  }) async {
    await cookieManager.setCookie(
      url: WebUri(url),
      name: name,
      value: value,
      domain: domain,
      path: path!,
    );
  }

  // 删除所有 cookies
  static Future<void> deleteAllCookies() async {
    await cookieManager.deleteAllCookies();
  }

  // 删除指定网站的 cookies
  static Future<void> deleteCookiesForSite(String url) async {
    await cookieManager.deleteCookies(url: WebUri(url));
  }

  // 打印所有 cookies
  static Future<void> printCookies(String url) async {
    final cookies = await getCookies(url);
    for (var cookie in cookies) {
      debugPrint('${cookie.name} = ${cookie.value}');
      debugPrint('Domain: ${cookie.domain}');
      debugPrint('Path: ${cookie.path}');
      debugPrint('Expiry: ${cookie.expiresDate}');
      debugPrint('---');
    }
  }
}

class CookieExporter {
  // 转换单个 cookie 为 Netscape 格式
  static String _formatCookieForNetscape(Cookie cookie) {
    // 格式：
    // domain  domain_flag  path  secure_flag  expiry  name  value
    bool isSecure = cookie.isSecure ?? false;
    String domain = cookie.domain?.startsWith('.') == true
        ? cookie.domain!
        : '.${cookie.domain}';

    // 计算过期时间戳
    int expiryTimestamp = 0;
    if (cookie.expiresDate != null) {
      expiryTimestamp = (cookie.expiresDate! / 1000).round();
    } else {
      // 如果没有过期时间，设置为一个月后
      expiryTimestamp =
          (DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch /
                  1000)
              .round();
    }

    return [
      domain, // domain (with leading dot)
      'TRUE', // domain_flag
      cookie.path ?? '/', // path
      isSecure ? 'TRUE' : 'FALSE', // secure_flag
      expiryTimestamp, // expiry timestamp in seconds
      cookie.name, // name
      cookie.value, // value
    ].join('\t');
  }

  // 保存 cookies 为 Netscape 格式文件
  static Future<String> saveCookiesForArdl(
      List<Cookie> cookies, String siteName) async {
    final directory = await getApplicationSupportDirectory();
    String path = p.join(directory.path, 'cookies');
    final cookieDir = Directory(path);
    await cookieDir.create(recursive: true);

    final fileName = '${siteName}_cookies.txt';
    String filePath = p.join(cookieDir.path, fileName);
    final file = File(filePath);

    final buffer = StringBuffer();
    // 添加 Netscape 格式的 cookie 文件头
    buffer.writeln('# Netscape HTTP Cookie File');
    buffer.writeln('# https://curl.haxx.se/rfc/cookie_spec.html');
    buffer.writeln(
        '# This file was generated by Ardl app. Edit at your own risk.');
    buffer.writeln('# ${DateTime.now()}');
    buffer.writeln();

    // 写入每个 cookie
    for (var cookie in cookies) {
      buffer.writeln(_formatCookieForNetscape(cookie));
    }

    await file.writeAsString(buffer.toString());
    return file.path;
  }
}
