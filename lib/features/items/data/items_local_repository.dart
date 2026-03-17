import 'package:hive/hive.dart';

import '../../../core/constants/hive_boxes.dart';
import '../../../core/models/item.dart';
import '../../../core/models/item_hive_dto.dart';

class ItemsLocalRepository {
  Box<ItemHiveDto> get _box => Hive.box<ItemHiveDto>(HiveBoxes.items);

  List<Item> getAll() => _box.values.map((e) => e.toItem()).toList();

  Future<void> upsertMany(List<Item> items) async {
    final map = {for (final i in items) i.id: ItemHiveDto.fromItem(i)};
    await _box.putAll(map);
  }

  Future<void> deleteById(String id) => _box.delete(id);

  Future<void> replaceAll(List<Item> items) async {
    await _box.clear();
    await upsertMany(items);
  }

  int count() => _box.length;
}
