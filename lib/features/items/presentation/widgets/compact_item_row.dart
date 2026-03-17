import 'package:flutter/material.dart';

import '../../../../core/models/item.dart';

class CompactItemRow extends StatelessWidget {
  final Item item;
  final bool pinned;
  final VoidCallback onOpen;
  final VoidCallback onPin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CompactItemRow({
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
    return ListTile(
      onTap: onOpen,
      title: Text(item.title),
      leading: IconButton(
        icon: Icon(pinned ? Icons.push_pin : Icons.push_pin_outlined),
        onPressed: onPin,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null) IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
          if (onDelete != null) IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }
}
