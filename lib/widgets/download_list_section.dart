import 'package:flutter/material.dart';
import '../../../widgets/download_list_item.dart';
import '../download_task_list.dart';
import '../services/settings_service.dart';

class DownloadListSection extends StatelessWidget {
  final List<DownloadTaskList> tasks;
  final bool hasMore;
  final bool isLoading;
  final ISettingsService settingsService;
  final Function(DownloadTaskList) onDelete;
  final Function(DownloadTaskList) onCancel;
  final Function(DownloadTaskList) openWeb;
  final Function(DownloadTaskList) onCopy;
  final Function(DownloadTaskList) reDownload;
  final VoidCallback onLoadMore;

  const DownloadListSection({
    super.key,
    required this.tasks,
    required this.hasMore,
    required this.isLoading,
    required this.settingsService,
    required this.onDelete,
    required this.onCancel,
    required this.openWeb,
    required this.onCopy,
    required this.reDownload,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.extentAfter == 0 &&
            !isLoading &&
            hasMore) {
          onLoadMore();
        }
        return true;
      },
      child: ListView.builder(
        itemCount: tasks.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= tasks.length) {
            return const LoadingIndicator();
          }
          return Material(
            elevation: 8, // 设置阴影高度
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2), // 设置圆角半径
            ),
            color: const Color.fromARGB(255, 255, 255, 255), // 设置背景颜色
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DownloadListItem(
                task: tasks[index],
                settingsService: settingsService,
                onDelete: onDelete,
                onCancel: onCancel,
                openWeb: openWeb,
                onCopy: onCopy,
                reDownload: reDownload,
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
