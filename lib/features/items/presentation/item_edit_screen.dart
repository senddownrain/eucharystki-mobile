import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/item.dart';
import '../../../core/widgets/snackbar_helper.dart';
import 'items_controller.dart';

class ItemEditScreen extends ConsumerStatefulWidget {
  final String? itemId;
  const ItemEditScreen({super.key, this.itemId});

  @override
  ConsumerState<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends ConsumerState<ItemEditScreen> {
  final _title = TextEditingController();
  final _html = TextEditingController();
  final _tags = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final id = widget.itemId;
    if (id != null) {
      final item = (ref.read(itemsControllerProvider).value ?? []).where((e) => e.id == id).firstOrNull;
      if (item != null) {
        _title.text = item.title;
        _html.text = item.text;
        _tags.text = item.tags.join(', ');
      }
    }
  }

  void _insertTag(String before, [String after = '']) {
    final selection = _html.selection;
    final text = _html.text;
    if (!selection.isValid) {
      _html.text += '$before$after';
      return;
    }
    final selected = text.substring(selection.start, selection.end);
    final replaced = text.replaceRange(selection.start, selection.end, '$before$selected$after');
    _html.text = replaced;
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      SnackbarHelper.show(context, 'Увядзіце загаловак');
      return;
    }
    setState(() => _loading = true);
    final id = widget.itemId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();
    final existing = (ref.read(itemsControllerProvider).value ?? []).where((e) => e.id == id).firstOrNull;

    final item = Item(
      id: id,
      title: _title.text.trim(),
      text: _html.text.trim(),
      tags: _tags.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList(),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      await ref.read(itemsControllerProvider.notifier).save(item);
      if (mounted) {
        SnackbarHelper.show(context, 'Захавана паспяхова');
        context.go('/');
      }
    } catch (e) {
      if (mounted) SnackbarHelper.show(context, 'Памылка захавання: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemId == null ? 'Новая нататка' : 'Рэдагаванне'),
        actions: [IconButton(onPressed: _loading ? null : _save, icon: const Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _title, decoration: const InputDecoration(labelText: 'Загаловак')),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(onPressed: () => _insertTag('<p>', '</p>'), child: const Text('P')),
                OutlinedButton(onPressed: () => _insertTag('<h2>', '</h2>'), child: const Text('H2')),
                OutlinedButton(onPressed: () => _insertTag('<strong>', '</strong>'), child: const Text('B')),
                OutlinedButton(onPressed: () => _insertTag('<em>', '</em>'), child: const Text('I')),
                OutlinedButton(
                  onPressed: () => _insertTag('<span style="color:red">', '</span>'),
                  child: const Text('Чырвоны'),
                ),
                OutlinedButton(onPressed: () => _insertTag('<ul><li>', '</li></ul>'), child: const Text('UL')),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _html,
              maxLines: 14,
              decoration: const InputDecoration(labelText: 'HTML тэкст'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tags,
              decoration: const InputDecoration(labelText: 'Тэгі праз коску'),
            ),
          ],
        ),
      ),
    );
  }
}
