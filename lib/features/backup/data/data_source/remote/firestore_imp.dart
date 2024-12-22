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
    List<Map<String, dynamic>> items,
    String tableName,
  ) async {
    CollectionReference itemsCollection = fireStore.collection(tableName);
    if (items.isEmpty) throw Exception('No data to upload');

    try {
      WriteBatch batch = fireStore.batch();

      for (Map<String, dynamic> item in items) {
        String docId = tableName == 'Items'
            ? item['item_id'].replaceAll('/', '-')
            : item['sale_id'].toString();
        DocumentReference docRef = itemsCollection.doc(docId);
        batch.set(docRef, item);
      }

      await batch.commit();
    } catch (e) {
      throw Exception(e.toString());
    }

    // print('dbg before loop: ${items1.length}');
    // int ind = 0;

    // for (int i = 0; i < items.length; i++) {
    //   Map<String, dynamic> item = items[i];

    //   String docId = tableName == 'Items'
    //       ? item['item_id'].replaceAll('/', '-')
    //       : item['sale_id'].toString();

    //   DocumentReference<Object?> docRef = itemsCollection.doc(docId);

    //   // Use set to add/update document
    //   await docRef.set(item).catchError((error) {
    //     throw Exception(error.toString());
    //   });
    // }

    // print('dbg: after loop');
  }

  Future<void> _deleteCollection(
    String collectionName,
    CollectionReference collectionRef,
  ) async {
    try {
      // Get all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Delete each document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  List<Map<String, dynamic>> items1 = [
    {
      "item_id": "car hati blue poli_149.71",
      "item_name": "car hati blue poli",
      "item_quantity": 16.915,
      "item_unit_price": 149.7127937,
      "item_unit_type": "kg"
    },
    {
      "item_id": "car hati gray poli_192.23",
      "item_name": "car hati gray poli",
      "item_quantity": 12.07,
      "item_unit_price": 192.2380952,
      "item_unit_type": "kg"
    },
    {
      "item_id": "chalk_20.00",
      "item_name": "chalk",
      "item_quantity": 24,
      "item_unit_price": 20,
      "item_unit_type": "kg"
    },
    {
      "item_id": "china steel balca_236.00",
      "item_name": "china steel balca",
      "item_quantity": 1,
      "item_unit_price": 236,
      "item_unit_type": "kg"
    },
    {
      "item_id": "cikon kata (1.5\")_111.67",
      "item_name": "cikon kata (1.5\")",
      "item_quantity": 13.225,
      "item_unit_price": 111.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "cut screw.75 same china_0.29",
      "item_name": "cut screw.75 same china",
      "item_quantity": 432,
      "item_unit_price": 0.291666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "cut screw (1x7) same china_0.52",
      "item_name": "cut screw (1x7) same china",
      "item_quantity": 217,
      "item_unit_price": 0.520833333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "dhup_115.00",
      "item_name": "dhup",
      "item_quantity": 2,
      "item_unit_price": 115,
      "item_unit_type": "kg"
    },
    {
      "item_id": "dokan vara_1900.00",
      "item_name": "dokan vara",
      "item_quantity": 1,
      "item_unit_price": 1900,
      "item_unit_type": "kg"
    },
    {
      "item_id": "doptir china screw (1.5x12)_1.60",
      "item_name": "doptir china screw (1.5x12)",
      "item_quantity": 144,
      "item_unit_price": 1.597222222,
      "item_unit_type": "kg"
    },
    {
      "item_id": "doptir china screw (2x12)_2.08",
      "item_name": "doptir china screw (2x12)",
      "item_quantity": 144,
      "item_unit_price": 2.083333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "elamati furniture_120.00",
      "item_name": "elamati furniture",
      "item_quantity": 0.5,
      "item_unit_price": 120,
      "item_unit_type": "kg"
    },
    {
      "item_id": "entic kobja_5.17",
      "item_name": "entic kobja",
      "item_quantity": 73,
      "item_unit_price": 5.166666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "entic kobja (2.5\")_7.50",
      "item_name": "entic kobja (2.5\")",
      "item_quantity": 133,
      "item_unit_price": 7.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "fast atha 125_41.00",
      "item_name": "fast atha 125",
      "item_quantity": 6,
      "item_unit_price": 41,
      "item_unit_type": "kg"
    },
    {
      "item_id": "fast atha 250_68.00",
      "item_name": "fast atha 250",
      "item_quantity": 5,
      "item_unit_price": 68,
      "item_unit_type": "kg"
    },
    {
      "item_id": "Forma kagoj_44.81",
      "item_name": "Forma kagoj",
      "item_quantity": 183.02,
      "item_unit_price": 44.8125,
      "item_unit_type": "kg"
    },
    {
      "item_id": "furniture color sorisa_250.00",
      "item_name": "furniture color sorisa",
      "item_quantity": 0.1,
      "item_unit_price": 250,
      "item_unit_type": "kg"
    },
    {
      "item_id": "gadar_470.00",
      "item_name": "gadar",
      "item_quantity": 1,
      "item_unit_price": 470,
      "item_unit_type": "kg"
    },
    {
      "item_id": "ghori shan_365.00",
      "item_name": "ghori shan",
      "item_quantity": 3,
      "item_unit_price": 365,
      "item_unit_type": "kg"
    },
    {
      "item_id": "gunar brush_32.50",
      "item_name": "gunar brush",
      "item_quantity": 12,
      "item_unit_price": 32.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "h flanger_100.00",
      "item_name": "h flanger",
      "item_quantity": 12,
      "item_unit_price": 100,
      "item_unit_type": "kg"
    },
    {
      "item_id": "handle (6\")_84.00",
      "item_name": "handle (6\")",
      "item_quantity": 12,
      "item_unit_price": 84,
      "item_unit_type": "kg"
    },
    {
      "item_id": "hatur 1 pound_137.50",
      "item_name": "hatur 1 pound",
      "item_quantity": 6,
      "item_unit_price": 137.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "hexa blade 1 no_10.00",
      "item_name": "hexa blade 1 no",
      "item_quantity": 36,
      "item_unit_price": 10,
      "item_unit_type": "kg"
    },
    {
      "item_id": "hexa blade 2 no_5.00",
      "item_name": "hexa blade 2 no",
      "item_quantity": 36,
      "item_unit_price": 5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "hook mota_6.00",
      "item_name": "hook mota",
      "item_quantity": 98,
      "item_unit_price": 6,
      "item_unit_type": "kg"
    },
    {
      "item_id": "humber tala 50_215.00",
      "item_name": "humber tala 50",
      "item_quantity": 2,
      "item_unit_price": 215,
      "item_unit_type": "kg"
    },
    {
      "item_id": "humber tala 60_300.00",
      "item_name": "humber tala 60",
      "item_quantity": 3,
      "item_unit_price": 300,
      "item_unit_type": "kg"
    },
    {
      "item_id": "humber tala 70_330.00",
      "item_name": "humber tala 70",
      "item_quantity": 4,
      "item_unit_price": 330,
      "item_unit_type": "kg"
    },
    {
      "item_id": "it ghosar brush boro_30.83",
      "item_name": "it ghosar brush boro",
      "item_quantity": 6,
      "item_unit_price": 30.83333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "it ghosar brush soto_21.67",
      "item_name": "it ghosar brush soto",
      "item_quantity": 6,
      "item_unit_price": 21.66666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "jiai tar 16 no_118.01",
      "item_name": "jiai tar 16 no",
      "item_quantity": 11.864,
      "item_unit_price": 118.0064309,
      "item_unit_type": "kg"
    },
    {
      "item_id": "jiai tar 16 no new_118.00",
      "item_name": "jiai tar 16 no new",
      "item_quantity": 20.5,
      "item_unit_price": 118,
      "item_unit_type": "kg"
    },
    {
      "item_id": "kalo kagoj 120_14.00",
      "item_name": "kalo kagoj 120",
      "item_quantity": 50,
      "item_unit_price": 14,
      "item_unit_type": "kg"
    },
    {
      "item_id": "kalo rong_28.00",
      "item_name": "kalo rong",
      "item_quantity": 44,
      "item_unit_price": 28,
      "item_unit_type": "kg"
    },
    {
      "item_id": "kapor_15.45",
      "item_name": "kapor",
      "item_quantity": 15,
      "item_unit_price": 15.45454545,
      "item_unit_type": "kg"
    },
    {
      "item_id": "karai boro_165.00",
      "item_name": "karai boro",
      "item_quantity": 3,
      "item_unit_price": 165,
      "item_unit_type": "kg"
    },
    {
      "item_id": "karai soto_140.00",
      "item_name": "karai soto",
      "item_quantity": 3,
      "item_unit_price": 140,
      "item_unit_type": "kg"
    },
    {
      "item_id": "karfa_420.00",
      "item_name": "karfa",
      "item_quantity": 1.9,
      "item_unit_price": 420,
      "item_unit_type": "kg"
    },
    {
      "item_id": "kata foam packet_15.83",
      "item_name": "kata foam packet",
      "item_quantity": 20,
      "item_unit_price": 15.83333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "kofil burnis_165.00",
      "item_name": "kofil burnis",
      "item_quantity": 10,
      "item_unit_price": 165,
      "item_unit_type": "kg"
    },
    {
      "item_id": "I boltu 4, 5 suta 8\"_131.13",
      "item_name": "I boltu 4, 5 suta 8\"",
      "item_quantity": 20.132,
      "item_unit_price": 131.1345122,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lal khoni rong_170.00",
      "item_name": "lal khoni rong",
      "item_quantity": 2.55,
      "item_unit_price": 170,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lal rong_36.00",
      "item_name": "lal rong",
      "item_quantity": 22.75,
      "item_unit_price": 36,
      "item_unit_type": "kg"
    },
    {
      "item_id": "light flanger_110.00",
      "item_name": "light flanger",
      "item_quantity": 4,
      "item_unit_price": 110,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion brush 1\"_23.33",
      "item_name": "lion brush 1\"",
      "item_quantity": 5,
      "item_unit_price": 23.33333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion brush 1.5\"_33.33",
      "item_name": "lion brush 1.5\"",
      "item_quantity": 2,
      "item_unit_price": 33.33333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion brush 2\"_40.00",
      "item_name": "lion brush 2\"",
      "item_quantity": 1,
      "item_unit_price": 40,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion brush 2.5\"_62.50",
      "item_name": "lion brush 2.5\"",
      "item_quantity": 6,
      "item_unit_price": 62.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion brush 3\"_79.00",
      "item_name": "lion brush 3\"",
      "item_quantity": 3,
      "item_unit_price": 79,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion brush 4\"_101.67",
      "item_name": "lion brush 4\"",
      "item_quantity": 0,
      "item_unit_price": 101.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion brush 5\"_145.67",
      "item_name": "lion brush 5\"",
      "item_quantity": 3,
      "item_unit_price": 145.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion screw 1.5_180.00",
      "item_name": "lion screw 1.5",
      "item_quantity": 6,
      "item_unit_price": 180,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion screw 1.75\"_183.33",
      "item_name": "lion screw 1.75\"",
      "item_quantity": 3,
      "item_unit_price": 183.3333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lux screw 1\"_181.67",
      "item_name": "lux screw 1\"",
      "item_quantity": 16.469,
      "item_unit_price": 181.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lux screw 1.75_180.00",
      "item_name": "lux screw 1.75",
      "item_quantity": 5.75,
      "item_unit_price": 180,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lux screw 2\", 2.5\"_169.81",
      "item_name": "lux screw 2\", 2.5\"",
      "item_quantity": 9.54,
      "item_unit_price": 169.8113208,
      "item_unit_type": "kg"
    },
    {
      "item_id": "mc puding_40.00",
      "item_name": "mc puding",
      "item_quantity": 20,
      "item_unit_price": 40,
      "item_unit_type": "kg"
    },
    {
      "item_id": "mikado glass tala_93.33",
      "item_name": "mikado glass tala",
      "item_quantity": 12,
      "item_unit_price": 93.33333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "mikado tala_115.00",
      "item_name": "mikado tala",
      "item_quantity": 12,
      "item_unit_price": 115,
      "item_unit_type": "kg"
    },
    {
      "item_id": "mili boltu 3\", 4\", 5\", 6\"_139.22",
      "item_name": "mili boltu 3\", 4\", 5\", 6\"",
      "item_quantity": 25.14,
      "item_unit_price": 139.220366,
      "item_unit_type": "kg"
    },
    {
      "item_id": "napthol_280.00",
      "item_name": "napthol",
      "item_quantity": 1,
      "item_unit_price": 280,
      "item_unit_type": "kg"
    },
    {
      "item_id": "nokia 3\" mota kobja_11.67",
      "item_name": "nokia 3\" mota kobja",
      "item_quantity": 178,
      "item_unit_price": 11.66666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "norom mom_214.96",
      "item_name": "norom mom",
      "item_quantity": 2.01,
      "item_unit_price": 214.9643705,
      "item_unit_type": "kg"
    },
    {
      "item_id": "onnonno khoros_900.00",
      "item_name": "onnonno khoros",
      "item_quantity": 10,
      "item_unit_price": 900,
      "item_unit_type": "kg"
    },
    {
      "item_id": "osar 2.5 suta_110.00",
      "item_name": "osar 2.5 suta",
      "item_quantity": 2,
      "item_unit_price": 110,
      "item_unit_type": "kg"
    },
    {
      "item_id": "osar 3 suta_95.00",
      "item_name": "osar 3 suta",
      "item_quantity": 41.65125,
      "item_unit_price": 95,
      "item_unit_type": "kg"
    },
    {
      "item_id": "osar 4 suta_100.00",
      "item_name": "osar 4 suta",
      "item_quantity": 14.52,
      "item_unit_price": 100,
      "item_unit_type": "kg"
    },
    {
      "item_id": "osar 5 suta_100.00",
      "item_name": "osar 5 suta",
      "item_quantity": 3,
      "item_unit_price": 100,
      "item_unit_type": "kg"
    },
    {
      "item_id": "prosi_45.30",
      "item_name": "prosi",
      "item_quantity": 1,
      "item_unit_price": 45.3,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pacmohori china 1 no_2.15",
      "item_name": "pacmohori china 1 no",
      "item_quantity": 384,
      "item_unit_price": 2.152777778,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pacmohori china 2 no_1.39",
      "item_name": "pacmohori china 2 no",
      "item_quantity": 576,
      "item_unit_price": 1.388888889,
      "item_unit_type": "kg"
    },
    {
      "item_id": "patam_107.63",
      "item_name": "patam",
      "item_quantity": 5.11,
      "item_unit_price": 107.6320939,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pathor cun_18.93",
      "item_name": "pathor cun",
      "item_quantity": 28,
      "item_unit_price": 18.92857143,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pati chac_1800.00",
      "item_name": "pati chac",
      "item_quantity": 1.2,
      "item_unit_price": 1800,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pati handle_32.50",
      "item_name": "pati handle",
      "item_quantity": 12,
      "item_unit_price": 32.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pitol tala 32_48.00",
      "item_name": "pitol tala 32",
      "item_quantity": 5,
      "item_unit_price": 48,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pitol tala 38_58.00",
      "item_name": "pitol tala 38",
      "item_quantity": 17,
      "item_unit_price": 58,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pitol tala 50_109.00",
      "item_name": "pitol tala 50",
      "item_quantity": 5,
      "item_unit_price": 109,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pitol tala 63_145.00",
      "item_name": "pitol tala 63",
      "item_quantity": 4,
      "item_unit_price": 145,
      "item_unit_type": "kg"
    },
    {
      "item_id": "plastic osar_3.50",
      "item_name": "plastic osar",
      "item_quantity": 14,
      "item_unit_price": 3.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "position_50000.00",
      "item_name": "position",
      "item_quantity": 1,
      "item_unit_price": 50000,
      "item_unit_type": "kg"
    },
    {
      "item_id": "protect drawer tala_105.00",
      "item_name": "protect drawer tala",
      "item_quantity": 7,
      "item_unit_price": 105,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pur atha_580.00",
      "item_name": "pur atha",
      "item_quantity": 2,
      "item_unit_price": 580,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pur atha 125_182.00",
      "item_name": "pur atha 125",
      "item_quantity": 5,
      "item_unit_price": 182,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pur atha 250_332.00",
      "item_name": "pur atha 250",
      "item_quantity": 5,
      "item_unit_price": 332,
      "item_unit_type": "kg"
    },
    {
      "item_id": "rat 4\"_22.92",
      "item_name": "rat 4\"",
      "item_quantity": 11,
      "item_unit_price": 22.91666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "rfl bucket boro_9.58",
      "item_name": "rfl bucket boro",
      "item_quantity": 21,
      "item_unit_price": 9.583333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "rfl bucket soto_7.50",
      "item_name": "rfl bucket soto",
      "item_quantity": 24,
      "item_unit_price": 7.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "rfl checkball_41.25",
      "item_name": "rfl checkball",
      "item_quantity": 17,
      "item_unit_price": 41.25,
      "item_unit_type": "kg"
    },
    {
      "item_id": "rfl heavy flanger_135.00",
      "item_name": "rfl heavy flanger",
      "item_quantity": 6,
      "item_unit_price": 135,
      "item_unit_type": "kg"
    },
    {
      "item_id": "rojom_260.00",
      "item_name": "rojom",
      "item_quantity": 1.9,
      "item_unit_price": 260,
      "item_unit_type": "kg"
    },
    {
      "item_id": "royal hatchball_225.00",
      "item_name": "royal hatchball",
      "item_quantity": 11,
      "item_unit_price": 225,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sada mom_226.00",
      "item_name": "sada mom",
      "item_quantity": 39.151,
      "item_unit_price": 226,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sada sish kagoj 100 no_23.00",
      "item_name": "sada sish kagoj 100 no",
      "item_quantity": 12,
      "item_unit_price": 23,
      "item_unit_type": "kg"
    },
    {
      "item_id": "same china cut screw 1.5x8_0.83",
      "item_name": "same china cut screw 1.5x8",
      "item_quantity": 144,
      "item_unit_price": 0.833333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sidur (furniture)_450.00",
      "item_name": "sidur (furniture)",
      "item_quantity": 0.5,
      "item_unit_price": 450,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sik 18\"_58.33",
      "item_name": "sik 18\"",
      "item_quantity": 12,
      "item_unit_price": 58.33333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sikol kamar_14.50",
      "item_name": "sikol kamar",
      "item_quantity": 36,
      "item_unit_price": 14.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sikol kamar mota_28.00",
      "item_name": "sikol kamar mota",
      "item_quantity": 71,
      "item_unit_price": 28,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sis kagoj sada_21.50",
      "item_name": "sis kagoj sada",
      "item_quantity": 40,
      "item_unit_price": 21.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sisha_420.00",
      "item_name": "sisha",
      "item_quantity": 1.18,
      "item_unit_price": 420,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sitkani 6\" sams com._75.00",
      "item_name": "sitkani 6\" sams com.",
      "item_quantity": 6,
      "item_unit_price": 75,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sitkani 8\" sams com._90.00",
      "item_name": "sitkani 8\" sams com.",
      "item_quantity": 12,
      "item_unit_price": 90,
      "item_unit_type": "kg"
    },
    {
      "item_id": "spreed 1 no_160.00",
      "item_name": "spreed 1 no",
      "item_quantity": 10,
      "item_unit_price": 160,
      "item_unit_type": "kg"
    },
    {
      "item_id": "spreed 2 no_100.00",
      "item_name": "spreed 2 no",
      "item_quantity": 10,
      "item_unit_price": 100,
      "item_unit_type": "kg"
    },
    {
      "item_id": "ss kobja 4\"_80.00",
      "item_name": "ss kobja 4\"",
      "item_quantity": 24,
      "item_unit_price": 80,
      "item_unit_type": "kg"
    },
    {
      "item_id": "steel kata 2\"_255.00",
      "item_name": "steel kata 2\"",
      "item_quantity": 2.92,
      "item_unit_price": 255,
      "item_unit_type": "kg"
    },
    {
      "item_id": "steel kata 2.5\"_255.00",
      "item_name": "steel kata 2.5\"",
      "item_quantity": 1.975,
      "item_unit_price": 255,
      "item_unit_type": "kg"
    },
    {
      "item_id": "steel kunni soto_41.67",
      "item_name": "steel kunni soto",
      "item_quantity": 3,
      "item_unit_price": 41.66666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "supper glue atha boro_80.00",
      "item_name": "supper glue atha boro",
      "item_quantity": 12,
      "item_unit_price": 80,
      "item_unit_type": "kg"
    },
    {
      "item_id": "supper glue atha soto_55.00",
      "item_name": "supper glue atha soto",
      "item_quantity": 12,
      "item_unit_price": 55,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sutli_154.97",
      "item_name": "sutli",
      "item_quantity": 5.18,
      "item_unit_price": 154.973822,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tar 12 no_115.06",
      "item_name": "tar 12 no",
      "item_quantity": 12.95,
      "item_unit_price": 115.0579151,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata 1.25\"_112.67",
      "item_name": "tarkata 1.25\"",
      "item_quantity": 3.45,
      "item_unit_price": 112.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata 1.25\"_106.67",
      "item_name": "tarkata 1.25\"",
      "item_quantity": 17.34431,
      "item_unit_price": 106.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata 2\"_106.67",
      "item_name": "tarkata 2\"",
      "item_quantity": 48.071,
      "item_unit_price": 106.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata 2.5\"_106.67",
      "item_name": "tarkata 2.5\"",
      "item_quantity": 40.06,
      "item_unit_price": 106.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata 3\"-4\"_106.67",
      "item_name": "tarkata 3\"-4\"",
      "item_quantity": 2.77,
      "item_unit_price": 106.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata 4\"_108.33",
      "item_name": "tarkata 4\"",
      "item_quantity": 3,
      "item_unit_price": 108.3333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata mota 1.5\"_320.00",
      "item_name": "tarkata mota 1.5\"",
      "item_quantity": 1,
      "item_unit_price": 320,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkatar osar_120.00",
      "item_name": "tarkatar osar",
      "item_quantity": 2,
      "item_unit_price": 120,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarpin boro_35.00",
      "item_name": "tarpin boro",
      "item_quantity": 5,
      "item_unit_price": 35,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarpin soto_17.00",
      "item_name": "tarpin soto",
      "item_quantity": 12,
      "item_unit_price": 17,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tc cut screw 1\"_0.22",
      "item_name": "tc cut screw 1\"",
      "item_quantity": 1704,
      "item_unit_price": 0.215277778,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tc cut screw 3/4\"_0.15",
      "item_name": "tc cut screw 3/4\"",
      "item_quantity": 1728,
      "item_unit_price": 0.145833333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tc tala 32_45.83",
      "item_name": "tc tala 32",
      "item_quantity": 11,
      "item_unit_price": 45.83333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tc tala 38_54.17",
      "item_name": "tc tala 38",
      "item_quantity": 10,
      "item_unit_price": 54.16666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tc tala 50_103.33",
      "item_name": "tc tala 50",
      "item_quantity": 5,
      "item_unit_price": 103.3333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tc tala 63_123.33",
      "item_name": "tc tala 63",
      "item_quantity": 5,
      "item_unit_price": 123.3333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "thiner lc_190.00",
      "item_name": "thiner lc",
      "item_quantity": 1,
      "item_unit_price": 190,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tiger kali_15.00",
      "item_name": "tiger kali",
      "item_quantity": 6,
      "item_unit_price": 15,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tin hati blue poli_151.18",
      "item_name": "tin hati blue poli",
      "item_quantity": 17,
      "item_unit_price": 151.1764706,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tin hati gray poli_190.48",
      "item_name": "tin hati gray poli",
      "item_quantity": 15.32,
      "item_unit_price": 190.4761905,
      "item_unit_type": "kg"
    },
    {
      "item_id": "wheel kagoj 2\", 2.5\"_22.50",
      "item_name": "wheel kagoj 2\", 2.5\"",
      "item_quantity": 44,
      "item_unit_price": 22.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "1\" pin kata_138.89",
      "item_name": "1\" pin kata",
      "item_quantity": 1.67,
      "item_unit_price": 138.8888889,
      "item_unit_type": "kg"
    },
    {
      "item_id": "1\" steel kata_300.00",
      "item_name": "1\" steel kata",
      "item_quantity": 1,
      "item_unit_price": 300,
      "item_unit_type": "kg"
    },
    {
      "item_id": "1.5\" steel kata_255.00",
      "item_name": "1.5\" steel kata",
      "item_quantity": 1,
      "item_unit_price": 255,
      "item_unit_type": "kg"
    },
    {
      "item_id": "13/22 cover_99.00",
      "item_name": "13/22 cover",
      "item_quantity": 4.675,
      "item_unit_price": 99,
      "item_unit_type": "kg"
    },
    {
      "item_id": "2\" al tala normal_5.00",
      "item_name": "2\" al tala normal",
      "item_quantity": 12,
      "item_unit_price": 5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "2\" al tala pitol_5.42",
      "item_name": "2\" al tala pitol",
      "item_quantity": 36,
      "item_unit_price": 5.416666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "2 aunch rong lal_11.67",
      "item_name": "2 aunch rong lal",
      "item_quantity": 12,
      "item_unit_price": 11.66666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "2 aunch rong sada_11.67",
      "item_name": "2 aunch rong sada",
      "item_quantity": 12,
      "item_unit_price": 11.66666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "2\" ss sitkani_21.67",
      "item_name": "2\" ss sitkani",
      "item_quantity": 24,
      "item_unit_price": 21.66666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "2.5 suta boltu 1\", 2\", 2.5\", 3\", 4\"_140.00",
      "item_name": "2.5 suta boltu 1\", 2\", 2.5\", 3\", 4\"",
      "item_quantity": 8.568,
      "item_unit_price": 140,
      "item_unit_type": "kg"
    },
    {
      "item_id": "25 tar_138.00",
      "item_name": "25 tar",
      "item_quantity": 36.931,
      "item_unit_price": 138,
      "item_unit_type": "kg"
    },
    {
      "item_id": "25 tar guna_136.00",
      "item_name": "25 tar guna",
      "item_quantity": 25,
      "item_unit_price": 136,
      "item_unit_type": "kg"
    },
    {
      "item_id": "3\" k band mota kobja_11.96",
      "item_name": "3\" k band mota kobja",
      "item_quantity": 0,
      "item_unit_price": 11.95833333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "3/4\" pin kata_138.89",
      "item_name": "3/4\" pin kata",
      "item_quantity": 1.4,
      "item_unit_price": 138.8888889,
      "item_unit_type": "kg"
    },
    {
      "item_id": "4\" diamond blade_75.00",
      "item_name": "4\" diamond blade",
      "item_quantity": 2,
      "item_unit_price": 75,
      "item_unit_type": "kg"
    },
    {
      "item_id": "4\" entic kobja_22.50",
      "item_name": "4\" entic kobja",
      "item_quantity": 31,
      "item_unit_price": 22.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "4\" ss handle_23.00",
      "item_name": "4\" ss handle",
      "item_quantity": 10,
      "item_unit_price": 23,
      "item_unit_type": "kg"
    },
    {
      "item_id": "5\" diamond blade_90.00",
      "item_name": "5\" diamond blade",
      "item_quantity": 2,
      "item_unit_price": 90,
      "item_unit_type": "kg"
    },
    {
      "item_id": "5\" nokia blade_90.00",
      "item_name": "5\" nokia blade",
      "item_quantity": 3,
      "item_unit_price": 90,
      "item_unit_type": "kg"
    },
    {
      "item_id": "6\" rat_53.33",
      "item_name": "6\" rat",
      "item_quantity": 12,
      "item_unit_price": 53.33333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "8\" kumir shan_70.00",
      "item_name": "8\" kumir shan",
      "item_quantity": 3,
      "item_unit_price": 70,
      "item_unit_type": "kg"
    },
    {
      "item_id": "bala boro_24.17",
      "item_name": "bala boro",
      "item_quantity": 12,
      "item_unit_price": 24.16666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "bala kamaira majhari_32.00",
      "item_name": "bala kamaira majhari",
      "item_quantity": 34,
      "item_unit_price": 32,
      "item_unit_type": "kg"
    },
    {
      "item_id": "bala majhari_9.17",
      "item_name": "bala majhari",
      "item_quantity": 24,
      "item_unit_price": 9.166666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "bala soto_7.92",
      "item_name": "bala soto",
      "item_quantity": 22,
      "item_unit_price": 7.916666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "barnis 200ml_66.00",
      "item_name": "barnis 200ml",
      "item_quantity": 16,
      "item_unit_price": 66,
      "item_unit_type": "kg"
    },
    {
      "item_id": "bedjoin kalo 3\" A_137.00",
      "item_name": "bedjoin kalo 3\" A",
      "item_quantity": 5,
      "item_unit_price": 137,
      "item_unit_type": "kg"
    },
    {
      "item_id": "bkh shan_11.00",
      "item_name": "bkh shan",
      "item_quantity": 42,
      "item_unit_price": 11,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 10 ml_139.00",
      "item_name": "boltu 10 ml",
      "item_quantity": 13.509,
      "item_unit_price": 139,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 2 suta 0.5\"_160.00",
      "item_name": "boltu 2 suta 0.5\"",
      "item_quantity": 0,
      "item_unit_price": 160,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 2 suta 1\"_150.00",
      "item_name": "boltu 2 suta 1\"",
      "item_quantity": 2,
      "item_unit_price": 150,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 2 suta 1.5\", 2\", 4\"_145.00",
      "item_name": "boltu 2 suta 1.5\", 2\", 4\"",
      "item_quantity": 6,
      "item_unit_price": 145,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 2.5 suta 0.5\"_160.00",
      "item_name": "boltu 2.5 suta 0.5\"",
      "item_quantity": 3,
      "item_unit_price": 160,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 3 suta 1\"_140.00",
      "item_name": "boltu 3 suta 1\"",
      "item_quantity": 2,
      "item_unit_price": 140,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 3 suta 1.5\"_132.50",
      "item_name": "boltu 3 suta 1.5\"",
      "item_quantity": 1.85,
      "item_unit_price": 132.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 3 suta 2\"_118.00",
      "item_name": "boltu 3 suta 2\"",
      "item_quantity": 1.87,
      "item_unit_price": 118,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 3 suta 2.5\"_118.00",
      "item_name": "boltu 3 suta 2.5\"",
      "item_quantity": 2,
      "item_unit_price": 118,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 3 suta 3\", 4\"_116.00",
      "item_name": "boltu 3 suta 3\", 4\"",
      "item_quantity": 87.03525,
      "item_unit_price": 116,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 3 suta 5\"_111.00",
      "item_name": "boltu 3 suta 5\"",
      "item_quantity": 43.77625,
      "item_unit_price": 111,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 3 suta 6\", 7\", 8\", 9\", 10\"_112.00",
      "item_name": "boltu 3 suta 6\", 7\", 8\", 9\", 10\"",
      "item_quantity": 68.33125,
      "item_unit_price": 112,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 4 suta 2.5\"_118.00",
      "item_name": "boltu 4 suta 2.5\"",
      "item_quantity": 12.549,
      "item_unit_price": 118,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 4 suta 3\", 4\", 5\", 6\"_118.00",
      "item_name": "boltu 4 suta 3\", 4\", 5\", 6\"",
      "item_quantity": 23.535,
      "item_unit_price": 118,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu 4 suta 7\", 8\"_116.62",
      "item_name": "boltu 4 suta 7\", 8\"",
      "item_quantity": 8.508,
      "item_unit_price": 116.6238387,
      "item_unit_type": "kg"
    },
    {
      "item_id": "borik_37.60",
      "item_name": "borik",
      "item_quantity": 16,
      "item_unit_price": 37.6,
      "item_unit_type": "kg"
    },
    {
      "item_id": "brawn_80.00",
      "item_name": "brawn",
      "item_quantity": 0.5,
      "item_unit_price": 80,
      "item_unit_type": "kg"
    },
    {
      "item_id": "cakti 20_150.00",
      "item_name": "cakti 20",
      "item_quantity": 8.75,
      "item_unit_price": 150,
      "item_unit_type": "kg"
    },
    {
      "item_id": "cakti cng_160.00",
      "item_name": "cakti cng",
      "item_quantity": 10.459,
      "item_unit_price": 160,
      "item_unit_type": "kg"
    },
    {
      "item_id": "camel drawer tala_48.33",
      "item_name": "camel drawer tala",
      "item_quantity": 11,
      "item_unit_price": 48.33333333,
      "item_unit_type": "kg"
    }
  ];
}
