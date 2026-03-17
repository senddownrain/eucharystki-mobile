import 'package:flutter/material.dart';

Future<Set<String>?> showTagFilterSheet(
  BuildContext context, {
  required List<String> allTags,
  required Set<String> selected,
}) {
  final current = {...selected};
  return showModalBottomSheet<Set<String>>(
    context: context,
    builder: (_) => StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Фільтр па тэгах'),
            Wrap(
              spacing: 8,
              children: allTags
                  .map((tag) => FilterChip(
                        label: Text(tag),
                        selected: current.contains(tag),
                        onSelected: (s) => setState(() => s ? current.add(tag) : current.remove(tag)),
                      ))
                  .toList(),
            ),
            const Spacer(),
            FilledButton(onPressed: () => Navigator.pop(context, current), child: const Text('Ужыць')),
          ],
        ),
      );
    }),
  );
}
