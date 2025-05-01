import 'package:flutter/material.dart';

void showCustomDialog(
  BuildContext context, {
  required String title,
  required String content,
  bool showCancelButton = true,
  VoidCallback? onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (showCancelButton)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm?.call();
          },
          child: const Text('确认'),
        ),
      ],
    ),
  );
}
