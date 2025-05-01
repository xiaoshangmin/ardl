import 'package:flutter/material.dart';
import 'dart:io';
import '../download_task_list.dart';
import '../services/settings_service.dart';
import '../widgets/thumbnail_preview_dialog.dart';
import '../utils/dialog_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DownloadListItem extends StatelessWidget {
  final DownloadTaskList task;
  final ISettingsService settingsService;
  final Function(DownloadTaskList) onDelete;
  final Function(DownloadTaskList) onCancel;
  final Function(DownloadTaskList) openWeb;
  final Function(DownloadTaskList) onCopy;
  final Function(DownloadTaskList) reDownload;

  const DownloadListItem({
    super.key,
    required this.task,
    required this.settingsService,
    required this.onDelete,
    required this.onCancel,
    required this.openWeb,
    required this.onCopy,
    required this.reDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 缩略图部分
                _buildThumbnail(context),
                const SizedBox(width: 16.0),

                // 标题和副标题部分
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 4.0),
                      _buildSubtitle(),
                    ],
                  ),
                ),

                // 操作按钮部分
                _buildActions(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (task.thumb.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => ThumbnailPreviewDialog(
              thumb: task.thumb,
            ),
          );
        }
      },
      child: task.thumb.isNotEmpty
          ? Image.memory(
              task.thumb,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            )
          : const Icon(Icons.image, size: 60),
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: SelectableText(
        task.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 1,
        scrollPhysics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(task.displayStatus),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showCancelButton(task))
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => onCancel(task),
            tooltip: AppLocalizations.of(context)!.cancelDownload,
          ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onDelete(task),
          color: Colors.red,
          tooltip: AppLocalizations.of(context)!.deleteTask,
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => reDownload(task),
          tooltip: AppLocalizations.of(context)!.reDownload,
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => onCopy(task),
          color: Colors.blue,
          tooltip: AppLocalizations.of(context)!.copyTaskUrl,
        ),
        IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: () => _openDownloadFolder(context),
          tooltip: AppLocalizations.of(context)!.openFolder,
        ),
        IconButton(
          onPressed: () => openWeb(task),
          icon: const Icon(Icons.cookie),
          color: const Color.fromARGB(255, 237, 211, 135),
          tooltip: AppLocalizations.of(context)!.openWeb,
        ),
      ],
    );
  }

  bool _showCancelButton(DownloadTaskList task) {
    if (task.status != TaskStatus.completed &&
        task.status != TaskStatus.error &&
        task.status != TaskStatus.cancelled &&
        task.status != TaskStatus.inProgress) {
      return true;
    }
    return false;
  }

  Future<void> _openDownloadFolder(BuildContext context) async {
    final path = await settingsService.getDownloadPath();
    if (path.isEmpty) {
      if (context.mounted) {
        showCustomDialog(
          context,
          title: '提示',
          content: '请先在设置中设置下载目录',
          showCancelButton: false,
        );
      }
      return;
    }

    try {
      final directory = Directory(path);
      if (await directory.exists()) {
        if (Platform.isMacOS) {
          Process.run('open', [path]);
        } else if (Platform.isWindows) {
          Process.run('explorer', [path]);
        } else if (Platform.isLinux) {
          Process.run('xdg-open', [path]);
        }
      } else {
        if (context.mounted) {
          showCustomDialog(
            context,
            title: '错误',
            content: '目录不存在: $path',
            showCancelButton: false,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showCustomDialog(
          context,
          title: '错误',
          content: '无法打开目录: $e',
          showCancelButton: false,
        );
      }
    }
  }
}
