bool isValidUrl(String url) {
  final urlPattern = r'^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$';
  return RegExp(urlPattern, caseSensitive: false).hasMatch(url);
}

String? matchUrl(String url) {
  final pattern = RegExp(
      r'^(?:https?:\/\/)?((?:[a-zA-Z0-9-]{1,63}\.)+[a-zA-Z]{2,63})(?::\d+)?(?=\/|$|\?)');
  final match = pattern.firstMatch(url);

  return match?.group(1).toString(); // 获取第一个捕获组
}

String getSiteName(String url) {
  String? domain = matchUrl(url);
  if (domain != null) {
    return domain.replaceAll('.', '_');
  }
  return '';
}

Map<String, dynamic>? parseProgress(String data) {
  // 匹配下载进度信息的正则表达式
  final progressRegex = RegExp(
    r'\[download\]\s+(\d+\.?\d*)%\s+of\s+~?\s*([\d\.]+(?:K|M|G)iB)(?:\s+at\s+([\d\.]+(?:K|M|G)iB/s))?\s+ETA\s+(\d+:\d+)',
  );

  final match = progressRegex.firstMatch(data);
  if (match != null) {
    return {
      'percentage': double.parse(match.group(1) ?? '0'),
      'fileSize': match.group(2) ?? 'Unknown',
      'speed': match.group(3) ?? 'Unknown',
      'time': match.group(4) ?? 'Unknown',
    };
  }
  return null;
}
