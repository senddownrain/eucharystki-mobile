import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Скасаваць')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Пацвердзіць')),
          ],
        ),
      ) ??
      false;
}
