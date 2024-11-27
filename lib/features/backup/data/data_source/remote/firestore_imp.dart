import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_source.dart';

class FireStoreImp implements BackupDataSource {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> restore(String tableName) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await fireStore.collection(tableName).get();
    // print(snapshot);
    return snapshot;
  }

  @override
  Future<void> upload(
    List<Map<String, dynamic>> items,
    String tableName,
  ) async {
    print(items);
    CollectionReference itemsCollection = fireStore.collection(tableName);
    if (items.isEmpty) return;
    WriteBatch batch = fireStore.batch();

    try {
      for (var item in items) {
        String docId =
            tableName == 'Items' ? item['item_id'] : item['sale_id'].toString();
        DocumentReference docRef = itemsCollection.doc(docId);
        batch.set(docRef, item);
      }

      await batch.commit();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
