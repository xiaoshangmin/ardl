import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UrlInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onDownload;

  const UrlInputSection({
    super.key,
    required this.controller,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.urlInputLabel,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DownloadButton(onPressed: onDownload),
        ),
      ],
    );
  }
}

class DownloadButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DownloadButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        minimumSize: const Size(100, 55),
        padding: const EdgeInsets.all(8),
      ),
      child: const Icon(Icons.file_download, size: 30),
    );
  }
}
