import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_source.dart';

class FireStoreImp implements BackupDataSource {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> restore(String tableName) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await fireStore.collection(tableName).get();
    return snapshot;
  }

  @override
  Future<void> upload(
    List<Map<String, dynamic>> items1,
    String tableName,
  ) async {
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

  List<Map<String, dynamic>> items = [
    {
      "item_id": "tc_tala_38_54.16666667",
      "item_name": "tc tala 38",
      "item_quantity": 10,
      "item_unit_price": 54.16666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tc_tala_50_103.3333333",
      "item_name": "tc tala 50",
      "item_quantity": 5,
      "item_unit_price": 103.3333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tc_tala_63_123.3333333",
      "item_name": "tc tala 63",
      "item_quantity": 5,
      "item_unit_price": 123.3333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tiger_kali_15.0",
      "item_name": "tiger kali",
      "item_quantity": 6,
      "item_unit_price": 15.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tin_hati_blue_poli_151.1764706",
      "item_name": "tin hati blue poli",
      "item_quantity": 17,
      "item_unit_price": 151.1764706,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tin_hati_gray_poli_190.4761905",
      "item_name": "tin hati gray poli",
      "item_quantity": 18.09,
      "item_unit_price": 190.4761905,
      "item_unit_type": "kg"
    },
    {
      "item_id": "wheel_kagoj_2_,_2.5_22.5",
      "item_name": "wheel kagoj 2\", 2.5\"",
      "item_quantity": 44,
      "item_unit_price": 22.5,
      "item_unit_type": "kg"
    }
  ];
}
