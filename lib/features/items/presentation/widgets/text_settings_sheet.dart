import 'package:flutter/material.dart';

Future<double?> showTextSettingsSheet(BuildContext context, double initial) {
  double current = initial;
  return showModalBottomSheet<double>(
    context: context,
    builder: (_) => StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Памер тэксту'),
          Slider(
            value: current,
            min: 0.8,
            max: 1.6,
            onChanged: (v) => setState(() => current = v),
          ),
          FilledButton(onPressed: () => Navigator.pop(context, current), child: const Text('Гатова')),
        ]),
      );
    }),
  );
}
