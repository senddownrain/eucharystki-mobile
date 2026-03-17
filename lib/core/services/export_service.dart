import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/item.dart';

class ExportService {
  Future<void> exportItems(List<Item> items) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/items_export.json');
    final payload = jsonEncode(items.map((e) => e.toJson()).toList());
    await file.writeAsString(payload);
    await Share.shareXFiles([XFile(file.path)], text: 'Экспарт нататак');
  }
}
