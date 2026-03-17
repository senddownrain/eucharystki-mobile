import 'package:hive/hive.dart';

import 'item.dart';

@HiveType(typeId: 1)
class ItemHiveDto extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String text;
  @HiveField(3)
  List<String> tags;
  @HiveField(4)
  DateTime? createdAt;
  @HiveField(5)
  DateTime? updatedAt;

  ItemHiveDto({
    required this.id,
    required this.title,
    required this.text,
    required this.tags,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemHiveDto.fromItem(Item item) => ItemHiveDto(
        id: item.id,
        title: item.title,
        text: item.text,
        tags: item.tags,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      );

  Item toItem() => Item(
        id: id,
        title: title,
        text: text,
        tags: tags,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

class ItemHiveDtoAdapter extends TypeAdapter<ItemHiveDto> {
  @override
  final typeId = 1;

  @override
  ItemHiveDto read(BinaryReader reader) {
    return ItemHiveDto(
      id: reader.readString(),
      title: reader.readString(),
      text: reader.readString(),
      tags: (reader.readList().cast<String>()),
      createdAt: reader.read(),
      updatedAt: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ItemHiveDto obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeString(obj.text)
      ..writeList(obj.tags)
      ..write(obj.createdAt)
      ..write(obj.updatedAt);
  }
}
