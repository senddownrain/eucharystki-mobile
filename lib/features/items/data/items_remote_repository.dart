import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/item.dart';

class ItemsRemoteRepository {
  final FirebaseFirestore firestore;
  ItemsRemoteRepository(this.firestore);

  Stream<List<Item>> watchItems() {
    return firestore
        .collection(AppConstants.firestoreItems)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Item.fromFirestore).toList());
  }

  Future<List<Item>> fetchAll() async {
    final snap = await firestore
        .collection(AppConstants.firestoreItems)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map(Item.fromFirestore).toList();
  }

  Future<void> save(Item item) async {
    final col = firestore.collection(AppConstants.firestoreItems);
    final now = Timestamp.now();
    if (item.id.isEmpty) {
      await col.add({
        ...item.toFirestore(),
        'createdAt': now,
        'updatedAt': now,
      });
      return;
    }
    await col.doc(item.id).set({
      ...item.toFirestore(),
      'createdAt': item.createdAt != null ? Timestamp.fromDate(item.createdAt!) : now,
      'updatedAt': now,
    });
  }

  Future<void> delete(String id) => firestore.collection(AppConstants.firestoreItems).doc(id).delete();
}
