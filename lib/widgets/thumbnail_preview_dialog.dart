import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../utils/dialog_utils.dart';

class ThumbnailPreviewDialog extends StatelessWidget {
  final Uint8List thumb;

  const ThumbnailPreviewDialog({required this.thumb, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('缩略图预览'),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Image.memory(
          thumb,
          fit: BoxFit.contain, // 使用contain确保图片完整显示
        ),
      ),
      actions: [
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                elevation: 6,
                minimumSize: Size(80, 50),
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
            child: const Text('关闭'),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => _saveThumbnail(context),
            style: ElevatedButton.styleFrom(
                elevation: 6,
                minimumSize: Size(80, 50),
                textStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveThumbnail(BuildContext context) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final filename = 'ardl_${DateTime.now().millisecondsSinceEpoch}.jpg';
      String filePath = path.join(appDir.path, filename);
      final file = File(filePath);
      await file.writeAsBytes(thumb);

      if (context.mounted) {
        showCustomDialog(
          context,
          title: '保存成功',
          content: '图片已保存到: ${file.path}',
          showCancelButton: false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showCustomDialog(
          context,
          title: '保存失败',
          content: e.toString(),
          showCancelButton: false,
        );
      }
    }
  }
}
