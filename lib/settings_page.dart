import 'dart:io';

import 'package:ardl/gen/assets.gen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import './services/settings_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './providers/locale_provider.dart';
import 'services/service_locator.dart';
import 'package:path/path.dart' as path;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _proxyController = TextEditingController();
  final TextEditingController _folderController = TextEditingController();
  final TextEditingController _ytDlpPathController = TextEditingController();
  final TextEditingController _ffmpegPathController = TextEditingController();
  late AppDatabase _db;
  late ISettingsService _settingsService;
  bool _showProxySettings = false;
  String _currentLanguage = 'zh';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _db = getIt<AppDatabase>();
    _settingsService = getIt<ISettingsService>();
    await _loadSettings();
    await initDownloadPath();
  }

  Future<void> initDownloadPath() async {
    if (_folderController.text.isEmpty) {
      _folderController.text = await _settingsService.getDownloadPath();
    }
  }

  Future<void> _loadSettings() async {
    Map<String, String?> settings = await _settingsService.getSettingsList();
    _proxyController.text = settings[SettingsKeys.proxyAddress] ?? "";
    bool showProxy =
        settings[SettingsKeys.showProxySettings]?.toLowerCase() == 'true';
    setState(() {
      _showProxySettings = showProxy;
    });
    _currentLanguage = settings[SettingsKeys.language] ?? 'zh';
    _folderController.text = settings[SettingsKeys.downloadPath] ?? "";
    _ytDlpPathController.text = settings[SettingsKeys.ytDlpPath] ?? "";
    _ffmpegPathController.text = settings[SettingsKeys.ffmpegPath] ?? "";
  }

  String getRelativePath(String fullPath) {
    // 获取当前用户的主目录
    String homeDir = Platform.environment['HOME'] ?? '/Users/unknown';

    if (fullPath.startsWith(homeDir)) {
      // 如果文件路径以主目录开始，则创建相对于主目录的路径
      return path.relative(fullPath, from: homeDir);
    }

    // 如果文件不在用户主目录下，返回原始路径或者考虑其他处理方式
    return fullPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.preferences),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.appVersion("v1.0.0"),
              style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          // 添加滚动内容的内边距（避免内容紧贴屏幕边缘）
          padding: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Material(
                elevation: 8, // 设置阴影高度
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2), // 设置圆角半径
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.language),
                      const SizedBox(width: 50),
                      DropdownButton<String>(
                        value: _currentLanguage,
                        padding: EdgeInsets.all(5),
                        focusColor: Colors.white,
                        underline: Container(),
                        borderRadius: BorderRadius.circular(4),
                        items: const [
                          DropdownMenuItem(value: 'zh', child: Text('中文')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                        ],
                        onChanged: (String? newValue) async {
                          if (newValue != null) {
                            setState(() {
                              _currentLanguage = newValue;
                            });
                            await _settingsService.setLanguage(newValue);
                            if (mounted) {
                              Provider.of<LocaleProvider>(context,
                                      listen: false)
                                  .setLocale(Locale(newValue));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              Material(
                elevation: 8, // 设置阴影高度
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2), // 设置圆角半径
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.downloadPath),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _folderController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.folder),
                        onPressed: () async {
                          String? selectedFolder =
                              await FilePicker.platform.getDirectoryPath();
                          if (selectedFolder != null) {
                            _folderController.text = selectedFolder;
                            _settingsService.setDownloadPath(selectedFolder);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                elevation: 8, // 设置阴影高度
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2), // 设置圆角半径
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.ffmpegPath),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _ffmpegPathController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.folder),
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            _ffmpegPathController.text =
                                result.files.first.path!;
                            _settingsService
                                .setFfmpegPath(result.files.first.path!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                elevation: 8, // 设置阴影高度
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2), // 设置圆角半径
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.ytDlpPath),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _ytDlpPathController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.folder),
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            _ytDlpPathController.text =
                                result.files.first.path!;
                            _settingsService
                                .setYtDlpPath(result.files.first.path!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 5),
              Material(
                elevation: 8, // 设置阴影高度
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2), // 设置圆角半径
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text(AppLocalizations.of(context)!.proxy),
                          value: _showProxySettings,
                          onChanged: (bool? value) async {
                            setState(() {
                              _showProxySettings = value ?? false;
                            });
                            await _settingsService
                                .setShowProxySettings(_showProxySettings);
                          },
                        ),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          crossFadeState: _showProxySettings
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextField(
                              controller: _proxyController,
                              decoration: const InputDecoration(
                                hintText: '例如http代理：127.0.0.1:1086',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          secondChild: const SizedBox.shrink(),
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final proxyAddress = _proxyController.text;
                  await _settingsService.setProxyAddress(proxyAddress);
                  await _settingsService
                      .setShowProxySettings(_showProxySettings);
                  // 添加保存成功的Toast提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.saveSuccess),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    elevation: 6,
                    minimumSize: Size(120, 50),
                    textStyle: TextStyle(
                      fontSize: 18,
                    )),
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ]),
          ),
        ));
  }
}
