import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_page.dart';
import 'utils/common.dart';
import 'utils/dialog_utils.dart';
import 'widgets/app_bar_widget.dart';
import 'widgets/url_input_section.dart';
import 'widgets/webview_manager.dart';
import 'services/ardl_service.dart';
import 'services/settings_service.dart';
import 'download_task_list.dart';
import 'database/database.dart';
import 'utils/download_tools.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'utils/flutter_toast.dart';
import 'widgets/download_list_section.dart';
import 'services/service_locator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _urlController = TextEditingController();
  final List<DownloadTaskList> _downloadTasks = [];

  late DownloadTools _downloadTools;
  late ArdlService _ardlService;
  late ISettingsService _settingsService;
  late AppDatabase _db;
  final int _pageSize = 10; // 每页数据量
  int _currentPage = 0; // 当前页码
  bool _hasMore = true; // 是否还有更多数据
  bool _isLoading = false; // 是否正在加载
  String _ytDlpPath = "";
  String _ffmpegPath = "";

  double _downloadProgress = 100;

  @override
  void initState() {
    super.initState();
    // _downloadTools = DownloadTools();
    // init();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _db = getIt<AppDatabase>();
    _ardlService = getIt.get<ArdlService>(param1: setState);
    _settingsService = getIt<ISettingsService>();
    await _loadHistoryDownloadTasks();
    await _initDownloadPath();
    await _initTools();
  }

  Future<void> init() async {
    await _downloadTools.initializeArdl(
      onProgress: (progress) => setState(() {
        _downloadProgress = progress;
        if (_downloadProgress == 100) {
          showToast(context, '初始化完成');
        }
      }),
    );
    await _downloadTools.initializeFfmpeg();
  }

  Future<void> _initDownloadPath() async {
    final downloadDir = await _settingsService.getDownloadPath();
    if (downloadDir.isEmpty) {
      final downloadDir = await getDownloadsDirectory();
      if (downloadDir != null) {
        await _settingsService.setDownloadPath(downloadDir.path);
      }
    }
  }

  Future<void> _initTools() async {
    _ytDlpPath = await _settingsService.getYtDlpPath();
    _ffmpegPath = await _settingsService.getFfmpegPath();
  }

  Future<void> _loadHistoryDownloadTasks({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      _downloadTasks.clear();
    }

    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await _ardlService.loadHistoryDownloadTasks(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      setState(() {
        if (tasks.length < _pageSize) {
          _hasMore = false;
        }
        _downloadTasks.addAll(tasks);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadVideo() async {
    if (_downloadProgress != 100) {
      showCustomDialog(
        context,
        title: AppLocalizations.of(context)!.tipText,
        content: AppLocalizations.of(context)!.initializing,
        showCancelButton: false,
      );
      return;
    }
    final url = _urlController.text.trim();
    if (!isValidUrl(url)) {
      showCustomDialog(
        context,
        title: AppLocalizations.of(context)!.tipText,
        content: AppLocalizations.of(context)!.urlValidationMessage,
        showCancelButton: false,
      );
      return;
    }

    if (_downloadTasks.any((task) => task.url == url)) {
      showCustomDialog(context,
          title: AppLocalizations.of(context)!.tipText,
          content: AppLocalizations.of(context)!.duplicateTaskMessage,
          showCancelButton: false);
      return;
    }
    _urlController.text = "";
    await _doDownloadVideo(url);
  }

  Future<void> _doDownloadVideo(String url) async {
    final newTask = DownloadTaskList(url);
    int id = await _ardlService.saveTasks(newTask);
    newTask.id = id;
    setState(() {
      _downloadTasks.insert(0, newTask);
    });

    await _ardlService.startDownload(newTask, _ytDlpPath, _ffmpegPath);
  }

  Future<void> _openWeb(String url) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DesktopWebView(
          url: url,
          onCookiesReceived: (cookiePath, siteName, expiry) {
            _db.updateOrInsertCookie(siteName, cookiePath, expiry);
          },
        ),
      ),
    );
  }

  Future<void> _onCopy(DownloadTaskList task) async {
    await Clipboard.setData(ClipboardData(text: task.url));
    if (mounted) {
      showToast(context, AppLocalizations.of(context)!.linkCopiedMessage);
    }
  }

  Future<void> _reDownload(DownloadTaskList task) async {
    showCustomDialog(context,
        title: AppLocalizations.of(context)!.tipText,
        content: AppLocalizations.of(context)!.retryDownloadMessage,
        onConfirm: () async =>
            {await _ardlService.startDownload(task, _ytDlpPath, _ffmpegPath)});
  }

  Future<void> _deleteTask(int index) async {
    final task = _downloadTasks[index];
    task.cancel(); // 取消下载
    setState(() {
      _downloadTasks.removeAt(index);
    });
    await _ardlService.deleteTaskById(task.id); // 删除数据库中的任务
  }

  Future<void> _onCancel(DownloadTaskList task) async {
    task.cancel();
  }

  Future<void> _launchURL() async {
    const url = 'https://github.com/xiaoshangmin/ardl';
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 35,
            color: const Color.fromARGB(255, 29, 29, 29),
            onPressed: _launchURL,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: 35,
            color: Colors.blue,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _downloadProgress < 100
          ? Container(
              height: 40,
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.initializing),
                  const SizedBox(width: 10),
                  Text(
                    '${_downloadProgress}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth > 600.0 ? 30.0 : 15.0;
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
          child: Column(
            children: [
              UrlInputSection(
                  controller: _urlController, onDownload: _downloadVideo),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: DownloadListSection(
                  tasks: _downloadTasks,
                  hasMore: _hasMore,
                  isLoading: _isLoading,
                  settingsService: _settingsService,
                  onDelete: (task) => _deleteTask(_downloadTasks.indexOf(task)),
                  onCancel: (task) => _onCancel(task),
                  openWeb: (task) => _openWeb(task.url),
                  onCopy: (task) => _onCopy(task),
                  reDownload: (task) => _reDownload(task),
                  onLoadMore: () => _loadHistoryDownloadTasks(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
