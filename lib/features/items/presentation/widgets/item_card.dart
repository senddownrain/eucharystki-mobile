import 'package:flutter/material.dart';

import '../../../../core/models/item.dart';
import '../../../../core/utils/html_utils.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool pinned;
  final VoidCallback onOpen;
  final VoidCallback onPin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemCard({
    super.key,
    required this.item,
    required this.pinned,
    required this.onOpen,
    required this.onPin,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onOpen,
        title: Text(item.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(HtmlUtils.preview(item.text)),
            const SizedBox(height: 6),
            Wrap(spacing: 6, children: item.tags.map((t) => Chip(label: Text(t))).toList()),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'pin') onPin();
            if (v == 'edit') onEdit?.call();
            if (v == 'delete') onDelete?.call();
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'pin', child: Text(pinned ? 'Адмацаваць' : 'Замацаваць')),
            if (onEdit != null) const PopupMenuItem(value: 'edit', child: Text('Рэдагаваць')),
            if (onDelete != null) const PopupMenuItem(value: 'delete', child: Text('Выдаліць')),
          ],
        ),
      ),
    );
  }
}
