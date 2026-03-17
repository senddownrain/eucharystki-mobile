import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String title;
  final String text;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Item({
    required this.id,
    required this.title,
    required this.text,
    required this.tags,
    this.createdAt,
    this.updatedAt,
  });

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Item(
      id: doc.id,
      title: (data['title'] as String?) ?? '',
      text: (data['text'] as String?) ?? '',
      tags: ((data['tags'] as List?) ?? []).map((e) => '$e').toList(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        text: json['text'] as String? ?? '',
        tags: ((json['tags'] as List?) ?? []).map((e) => '$e').toList(),
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
        updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'text': text,
        'tags': tags,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'text': text,
        'tags': tags,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
        'updatedAt': Timestamp.now(),
      };
}
