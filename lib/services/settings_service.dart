import '../database/database.dart';

/// 设置服务的抽象接口
abstract class ISettingsService {
  Future<Map<String, String?>> getSettingsList();
  Future<String> getProxyAddress();
  Future<void> setProxyAddress(String address);
  Future<String> getDownloadPath();
  Future<String> getFfmpegPath();
  Future<String> getYtDlpPath();
  Future<void> setDownloadPath(String path);
  Future<void> setFfmpegPath(String path);
  Future<void> setYtDlpPath(String path);
  Future<bool> getShowProxySettings();
  Future<void> setShowProxySettings(bool showProxySettings);
  Future<String> getLanguage();
  Future<void> setLanguage(String language);
}

/// 设置键名常量
class SettingsKeys {
  static const String proxyAddress = 'proxy_address';
  static const String downloadPath = 'download_path';
  static const String ytDlpPath = 'yt-dlp_path';
  static const String ffmpegPath = 'ffmpeg_path';
  static const String showProxySettings = 'show_proxy_settings';
  static const String language = 'language';

  static const List<String> allKeys = [
    proxyAddress,
    downloadPath,
    ytDlpPath,
    ffmpegPath,
    showProxySettings,
    language
  ];
}

/// 设置服务实现
class SettingsService implements ISettingsService {
  final AppDatabase db;

  SettingsService(this.db);

  @override
  Future<Map<String, String?>> getSettingsList() async {
    return await db.getSettingsList(SettingsKeys.allKeys);
  }

  @override
  Future<String> getProxyAddress() async {
    return await db.getSetting(SettingsKeys.proxyAddress) ?? "";
  }

  @override
  Future<void> setProxyAddress(String address) async {
    await db.updateOrInsertSettinng(SettingsKeys.proxyAddress, address);
  }

  @override
  Future<String> getDownloadPath() async {
    return await db.getSetting(SettingsKeys.downloadPath) ?? "";
  }

  @override
  Future<void> setDownloadPath(String path) async {
    await db.updateOrInsertSettinng(SettingsKeys.downloadPath, path);
  }

  @override
  Future<bool> getShowProxySettings() async {
    final result = await db.getSetting(SettingsKeys.showProxySettings);
    return result?.toLowerCase() == 'true';
  }

  @override
  Future<void> setShowProxySettings(bool showProxySettings) async {
    await db.updateOrInsertSettinng(
        SettingsKeys.showProxySettings, showProxySettings.toString());
  }

  @override
  Future<String> getLanguage() async {
    return await db.getSetting(SettingsKeys.language) ?? 'zh';
  }

  @override
  Future<void> setLanguage(String language) async {
    await db.updateOrInsertSettinng(SettingsKeys.language, language);
  }

  @override
  Future<void> setFfmpegPath(String path) async {
    await db.updateOrInsertSettinng(SettingsKeys.ffmpegPath, path);
  }

  @override
  Future<void> setYtDlpPath(String path) async {
    await db.updateOrInsertSettinng(SettingsKeys.ytDlpPath, path);
  }

  @override
  Future<String> getFfmpegPath() async {
    return await db.getSetting(SettingsKeys.ffmpegPath) ?? "";
  }

  @override
  Future<String> getYtDlpPath() async {
    return await db.getSetting(SettingsKeys.ytDlpPath) ?? "";
  }
}
