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
    try {
      CollectionReference itemsCollection = fireStore.collection(tableName);
      if (items.isEmpty) return;

      await _deleteCollection(tableName, itemsCollection);
      WriteBatch batch = fireStore.batch();

      for (var item in items) {
        String docId =
            tableName == 'Items' ? item['item_id'] : item['sale_id'].toString();
        DocumentReference docRef = itemsCollection.doc(docId);
        batch.set(docRef, item);
      }

      await batch.commit();
    } catch (e) {
      // print('dbg: exc: ${e.toString()}');
      throw Exception(e.toString());
    }
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
      print('dbg Collection $collectionName deleted successfully.');
    } catch (e) {
      print('dbg ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  List<Map<String, dynamic>> items1 = [
    {
      "item_id": "hexa_blade_2_no_5.00",
      "item_name": "hexa blade 2 no",
      "item_quantity": 36,
      "item_unit_price": 5.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "humber_tala_50_215.00",
      "item_name": "humber tala 50",
      "item_quantity": 2,
      "item_unit_price": 215.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "humber_tala_60_300.00",
      "item_name": "humber tala 60",
      "item_quantity": 3,
      "item_unit_price": 300.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "humber_tala_70_330.00",
      "item_name": "humber tala 70",
      "item_quantity": 4,
      "item_unit_price": 330.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "it_ghosar_brush_boro_30.83",
      "item_name": "it ghosar brush boro",
      "item_quantity": 6,
      "item_unit_price": 30.83333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "it_ghosar_brush_soto_21.67",
      "item_name": "it ghosar brush soto",
      "item_quantity": 6,
      "item_unit_price": 21.66666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "jiai_tar_16_no_118.01",
      "item_name": "jiai tar 16 no",
      "item_quantity": 15.054,
      "item_unit_price": 118.0064309,
      "item_unit_type": "kg"
    },
    {
      "item_id": "jiai_tar_16_no_new_118.00",
      "item_name": "jiai tar 16 no new",
      "item_quantity": 20.5,
      "item_unit_price": 118.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "kalo_kagoj_120_14.00",
      "item_name": "kalo kagoj 120",
      "item_quantity": 50,
      "item_unit_price": 14.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "kalo_rong_28.00",
      "item_name": "kalo rong",
      "item_quantity": 48,
      "item_unit_price": 28.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "kapor_15.45",
      "item_name": "kapor",
      "item_quantity": 16,
      "item_unit_price": 15.45454545,
      "item_unit_type": "other"
    },
    {
      "item_id": "karai_boro_165.00",
      "item_name": "karai boro",
      "item_quantity": 3,
      "item_unit_price": 165.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "karai_soto_140.00",
      "item_name": "karai soto",
      "item_quantity": 3,
      "item_unit_price": 140.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "karfa_420.00",
      "item_name": "karfa",
      "item_quantity": 2,
      "item_unit_price": 420.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "kata_foam_packet_15.83",
      "item_name": "kata foam packet",
      "item_quantity": 23,
      "item_unit_price": 15.83333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "I_boltu_4,_5_suta_8_131.13",
      "item_name": "I boltu 4, 5 suta 8\"",
      "item_quantity": 20.132,
      "item_unit_price": 131.1345122,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lal_khoni_rong_170.00",
      "item_name": "lal khoni rong",
      "item_quantity": 2.95,
      "item_unit_price": 170.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "lal_rong_36.00",
      "item_name": "lal rong",
      "item_quantity": 24.75,
      "item_unit_price": 36.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "light_flanger_110.00",
      "item_name": "light flanger",
      "item_quantity": 5,
      "item_unit_price": 110.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "lion_brush_1_23.33",
      "item_name": "lion brush 1\"",
      "item_quantity": 6,
      "item_unit_price": 23.33333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "lion_brush_1.5_33.33",
      "item_name": "lion brush 1.5\"",
      "item_quantity": 3,
      "item_unit_price": 33.33333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "lion_brush_2_40.00",
      "item_name": "lion brush 2\"",
      "item_quantity": 1,
      "item_unit_price": 40.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "lion_brush_2.5_62.50",
      "item_name": "lion brush 2.5\"",
      "item_quantity": 6,
      "item_unit_price": 62.5,
      "item_unit_type": "piece"
    },
    {
      "item_id": "camel_drawer_tala_48.33",
      "item_name": "camel drawer tala",
      "item_quantity": 11,
      "item_unit_price": 48.33333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "car_hati_blue_poli_149.71",
      "item_name": "car hati blue poli",
      "item_quantity": 17.885,
      "item_unit_price": 149.7127937,
      "item_unit_type": "kg"
    },
    {
      "item_id": "car_hati_gray_poli_192.24",
      "item_name": "car hati gray poli",
      "item_quantity": 12.985,
      "item_unit_price": 192.2380952,
      "item_unit_type": "kg"
    },
    {
      "item_id": "chalk_20.00",
      "item_name": "chalk",
      "item_quantity": 25,
      "item_unit_price": 20.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "china_steel_balca_236.00",
      "item_name": "china steel balca",
      "item_quantity": 2,
      "item_unit_price": 236.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "cut_screw_.75_same_china_0.29",
      "item_name": "cut screw.75 same china",
      "item_quantity": 432,
      "item_unit_price": 0.291666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "cut_screw_1x7_same_china_0.52",
      "item_name": "cut screw 1x7 same china",
      "item_quantity": 372,
      "item_unit_price": 0.520833333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "dhup_115.00",
      "item_name": "dhup",
      "item_quantity": 2,
      "item_unit_price": 115.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "dokan_vara_1900.00",
      "item_name": "dokan vara",
      "item_quantity": 1,
      "item_unit_price": 1900.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "doptir_china_screw_1.5x12_1.60",
      "item_name": "doptir china screw 1.5x12",
      "item_quantity": 144,
      "item_unit_price": 1.597222222,
      "item_unit_type": "kg"
    },
    {
      "item_id": "doptir_china_screw_2x12_2.08",
      "item_name": "doptir china screw 2x12",
      "item_quantity": 144,
      "item_unit_price": 2.083333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "elamati_furniture_120.00",
      "item_name": "elamati furniture",
      "item_quantity": 0.5,
      "item_unit_price": 120.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "entic_kobja_2_5.17",
      "item_name": "entic kobja 2\"",
      "item_quantity": 99,
      "item_unit_price": 5.166666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "entic_kobja_2.5_7.50",
      "item_name": "entic kobja 2.5\"",
      "item_quantity": 135,
      "item_unit_price": 7.5,
      "item_unit_type": "piece"
    },
    {
      "item_id": "Forma_kagoj_45.00",
      "item_name": "Forma kagoj",
      "item_quantity": 150.4,
      "item_unit_price": 45.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "furniture_color_sorisa_250.00",
      "item_name": "furniture color sorisa",
      "item_quantity": 0.1,
      "item_unit_price": 250.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "gadar_470.00",
      "item_name": "gadar",
      "item_quantity": 1,
      "item_unit_price": 470.0,
      "item_unit_type": "other"
    },
    {
      "item_id": "ghori_shan_365.00",
      "item_name": "ghori shan",
      "item_quantity": 3,
      "item_unit_price": 365.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "gunar_brush_32.50",
      "item_name": "gunar brush",
      "item_quantity": 12,
      "item_unit_price": 32.5,
      "item_unit_type": "piece"
    },
    {
      "item_id": "h_flanger_100.00",
      "item_name": "h flanger",
      "item_quantity": 12,
      "item_unit_price": 100.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "handle_6_84.00",
      "item_name": "handle 6\"",
      "item_quantity": 12,
      "item_unit_price": 84.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "hatur_1_pound_137.50",
      "item_name": "hatur 1 pound",
      "item_quantity": 6,
      "item_unit_price": 137.5,
      "item_unit_type": "piece"
    },
    {
      "item_id": "hexa_blade_1_no_10.00",
      "item_name": "hexa blade 1 no",
      "item_quantity": 36,
      "item_unit_price": 10.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "lion_brush_3_79.00",
      "item_name": "lion brush 3\"",
      "item_quantity": 3,
      "item_unit_price": 79.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "lion_brush_4_101.67",
      "item_name": "lion brush 4\"",
      "item_quantity": 0,
      "item_unit_price": 101.6666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "lion_brush_5_145.67",
      "item_name": "lion brush 5\"",
      "item_quantity": 3,
      "item_unit_price": 145.6666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "lion_screw_1.5_180.00",
      "item_name": "lion screw 1.5",
      "item_quantity": 6,
      "item_unit_price": 180.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lion_screw_1.75_183.33",
      "item_name": "lion screw 1.75\"",
      "item_quantity": 3,
      "item_unit_price": 183.3333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lux_screw_1.5_181.67",
      "item_name": "lux screw 1.5",
      "item_quantity": 17.515,
      "item_unit_price": 181.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lux_screw_1.75_180.00",
      "item_name": "lux screw 1.75",
      "item_quantity": 6,
      "item_unit_price": 180.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "lux_screw_2_,_2.5_169.81",
      "item_name": "lux screw 2\", 2.5\"",
      "item_quantity": 9.54,
      "item_unit_price": 169.8113208,
      "item_unit_type": "kg"
    },
    {
      "item_id": "mc_puding_40.00",
      "item_name": "mc puding",
      "item_quantity": 20,
      "item_unit_price": 40.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "mikado_glass_tala_93.33",
      "item_name": "mikado glass tala",
      "item_quantity": 12,
      "item_unit_price": 93.33333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "mikado_tala_115.00",
      "item_name": "mikado tala",
      "item_quantity": 12,
      "item_unit_price": 115.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "mili_boltu_3_,_4_,_5_,_6_139.22",
      "item_name": "mili boltu 3\", 4\", 5\", 6\"",
      "item_quantity": 25.14,
      "item_unit_price": 139.220366,
      "item_unit_type": "piece"
    },
    {
      "item_id": "napthol_280.00",
      "item_name": "napthol",
      "item_quantity": 1,
      "item_unit_price": 280.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "norom_mom_214.96",
      "item_name": "norom mom",
      "item_quantity": 3.11,
      "item_unit_price": 214.9643705,
      "item_unit_type": "piece"
    },
    {
      "item_id": "onnonno_khoros_2000.00",
      "item_name": "onnonno khoros",
      "item_quantity": 9,
      "item_unit_price": 2000.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "osar_3_suta_95.00",
      "item_name": "osar 3 suta",
      "item_quantity": 43.10125,
      "item_unit_price": 95.0,
      "item_unit_type": "Kg"
    },
    {
      "item_id": "osar_4_suta_100.00",
      "item_name": "osar 4 suta",
      "item_quantity": 14.52,
      "item_unit_price": 100.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "p_rosi_45.30",
      "item_name": "p rosi",
      "item_quantity": 5,
      "item_unit_price": 45.3,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pacmohori_china_1_no_2.15",
      "item_name": "pacmohori china 1 no",
      "item_quantity": 384,
      "item_unit_price": 2.152777778,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pacmohori_china_2_no_1.39",
      "item_name": "pacmohori china 2 no",
      "item_quantity": 576,
      "item_unit_price": 1.388888889,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pati_chac_1800.00",
      "item_name": "pati chac",
      "item_quantity": 1.4,
      "item_unit_price": 1800.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "pati_handle_32.50",
      "item_name": "pati handle",
      "item_quantity": 12,
      "item_unit_price": 32.5,
      "item_unit_type": "piece"
    },
    {
      "item_id": "pitol_tala_32_48.00",
      "item_name": "pitol tala 32",
      "item_quantity": 7,
      "item_unit_price": 48.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "pitol_tala_38_58.00",
      "item_name": "pitol tala 38",
      "item_quantity": 17,
      "item_unit_price": 58.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "pitol_tala_50_109.00",
      "item_name": "pitol tala 50",
      "item_quantity": 5,
      "item_unit_price": 109.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "pitol_tala_63_145.00",
      "item_name": "pitol tala 63",
      "item_quantity": 6,
      "item_unit_price": 145.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "plastic_osar_3.50",
      "item_name": "plastic osar",
      "item_quantity": 11,
      "item_unit_price": 3.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "position_50000.00",
      "item_name": "position",
      "item_quantity": 1,
      "item_unit_price": 50000.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "protect_drawer_tala_105.00",
      "item_name": "protect drawer tala",
      "item_quantity": 8,
      "item_unit_price": 105.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "pur_atha_580.00",
      "item_name": "pur atha",
      "item_quantity": 5,
      "item_unit_price": 580.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "pur_atha_125_182.00",
      "item_name": "pur atha 125",
      "item_quantity": 5,
      "item_unit_price": 182.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "pur_atha_250_332.00",
      "item_name": "pur atha 250",
      "item_quantity": 5,
      "item_unit_price": 332.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "rat_4_22.92",
      "item_name": "rat 4\"",
      "item_quantity": 11,
      "item_unit_price": 22.91666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "rfl_bucket_boro_9.58",
      "item_name": "rfl bucket boro",
      "item_quantity": 23,
      "item_unit_price": 9.583333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "rfl_bucket_soto_7.50",
      "item_name": "rfl bucket soto",
      "item_quantity": 24,
      "item_unit_price": 7.5,
      "item_unit_type": "piece"
    },
    {
      "item_id": "rfl_checkball_41.25",
      "item_name": "rfl checkball",
      "item_quantity": 19,
      "item_unit_price": 41.25,
      "item_unit_type": "piece"
    },
    {
      "item_id": "rfl_heavy_flanger_135.00",
      "item_name": "rfl heavy flanger",
      "item_quantity": 6,
      "item_unit_price": 135.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "rojom_260.00",
      "item_name": "rojom",
      "item_quantity": 2,
      "item_unit_price": 260.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "royal_hatchball_225.00",
      "item_name": "royal hatchball",
      "item_quantity": 12,
      "item_unit_price": 225.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "sada_mom_226.00",
      "item_name": "sada mom",
      "item_quantity": 34.416,
      "item_unit_price": 226.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "sada_sish_kagoj_100_no_23.00",
      "item_name": "sada sish kagoj 100 no",
      "item_quantity": 12,
      "item_unit_price": 23.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "same_china_cut_screw_1.5x8_0.83",
      "item_name": "same china cut screw 1.5x8",
      "item_quantity": 144,
      "item_unit_price": 0.833333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sidur_(furniture)_450.00",
      "item_name": "sidur (furniture)",
      "item_quantity": 0.5,
      "item_unit_price": 450.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sik_18_58.33",
      "item_name": "sik 18\"",
      "item_quantity": 12,
      "item_unit_price": 58.333333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "sikol_kamar_14.50",
      "item_name": "sikol kamar",
      "item_quantity": 36,
      "item_unit_price": 14.5,
      "item_unit_type": "piece"
    },
    {
      "item_id": "sis_kagoj_sada_21.50",
      "item_name": "sis kagoj sada",
      "item_quantity": 44,
      "item_unit_price": 21.5,
      "item_unit_type": "piece"
    },
    {
      "item_id": "sisha_420.00",
      "item_name": "sisha",
      "item_quantity": 1.68,
      "item_unit_price": 420.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sitkani_6_sams_com._75.00",
      "item_name": "sitkani 6\" sams com.",
      "item_quantity": 12,
      "item_unit_price": 75.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "sitkani_8_sams_com._90.00",
      "item_name": "sitkani 8\" sams com.",
      "item_quantity": 12,
      "item_unit_price": 90.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "ss_kobja_4_80.00",
      "item_name": "ss kobja 4\"",
      "item_quantity": 24,
      "item_unit_price": 80.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "steel_kata_2_255.00",
      "item_name": "steel kata 2\"",
      "item_quantity": 2.92,
      "item_unit_price": 255.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "steel_kata_2.5_255.00",
      "item_name": "steel kata 2.5\"",
      "item_quantity": 1.975,
      "item_unit_price": 255.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "steel_kunni_soto_41.67",
      "item_name": "steel kunni soto",
      "item_quantity": 3,
      "item_unit_price": 41.66666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "sutli_154.97",
      "item_name": "sutli",
      "item_quantity": 6.28,
      "item_unit_price": 154.973822,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tar_12_no_115.06",
      "item_name": "tar 12 no",
      "item_quantity": 12.95,
      "item_unit_price": 115.0579151,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata_1.25_112.67",
      "item_name": "tarkata 1.25\"",
      "item_quantity": 9.125,
      "item_unit_price": 112.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata_1.25_106.67",
      "item_name": "tarkata 1.25\"",
      "item_quantity": 17.34431,
      "item_unit_price": 106.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata_2_106.67",
      "item_name": "tarkata 2\"",
      "item_quantity": 55.096,
      "item_unit_price": 106.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata_2.5_106.67",
      "item_name": "tarkata 2.5\"",
      "item_quantity": 40.76,
      "item_unit_price": 106.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata_3_4_106.67",
      "item_name": "tarkata 3\"-4\"",
      "item_quantity": 3.02,
      "item_unit_price": 106.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata_4_108.33",
      "item_name": "tarkata 4\"",
      "item_quantity": 3,
      "item_unit_price": 108.3333333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata_cikon_1.5_111.67",
      "item_name": "tarkata cikon 1.5\"",
      "item_quantity": 5.525,
      "item_unit_price": 111.6666667,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkata_mota_1.5_320.00",
      "item_name": "tarkata mota 1.5\"",
      "item_quantity": 1,
      "item_unit_price": 320.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarkatar_osar_120.00",
      "item_name": "tarkatar osar",
      "item_quantity": 2,
      "item_unit_price": 120.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarpin_boro_35.00",
      "item_name": "tarpin boro",
      "item_quantity": 6,
      "item_unit_price": 35.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tarpin_soto_17.00",
      "item_name": "tarpin soto",
      "item_quantity": 12,
      "item_unit_price": 17.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tc_cut_screw_1_0.26",
      "item_name": "tc cut screw 1\"",
      "item_quantity": 1704,
      "item_unit_price": 0.215277778,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tc_cut_screw_3_4_0.15",
      "item_name": "tc cut screw 3/4\"",
      "item_quantity": 1728,
      "item_unit_price": 0.145833333,
      "item_unit_type": "kg"
    },
    {
      "item_id": "tc_tala_32_45.83",
      "item_name": "tc tala 32",
      "item_quantity": 11,
      "item_unit_price": 45.833333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tc_tala_38_54.17",
      "item_name": "tc tala 38",
      "item_quantity": 10,
      "item_unit_price": 54.17,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tc_tala_50_103.33",
      "item_name": "tc tala 50",
      "item_quantity": 5,
      "item_unit_price": 103.3333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tc_tala_63_123.33",
      "item_name": "tc tala 63",
      "item_quantity": 5,
      "item_unit_price": 123.3333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tiger_kali_15.00",
      "item_name": "tiger kali",
      "item_quantity": 6,
      "item_unit_price": 15.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tin_hati_blue_poli_151.18",
      "item_name": "tin hati blue poli",
      "item_quantity": 17,
      "item_unit_price": 151.1764706,
      "item_unit_type": "piece"
    },
    {
      "item_id": "tin_hati_gray_poli_190.48",
      "item_name": "tin hati gray poli",
      "item_quantity": 18.09,
      "item_unit_price": 190.4761905,
      "item_unit_type": "piece"
    },
    {
      "item_id": "wheel_kagoj_2_,_2.5_22.50",
      "item_name": "wheel kagoj 2\", 2.5\"",
      "item_quantity": 44,
      "item_unit_price": 22.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "bala_boro_24.17",
      "item_name": "bala boro",
      "item_quantity": 12,
      "item_unit_price": 24.16666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "bala_mohri_24.17",
      "item_name": "bala mohri",
      "item_quantity": 12,
      "item_unit_price": 24.16666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "bala_boro_24.17",
      "item_name": "bala boro",
      "item_quantity": 12,
      "item_unit_price": 24.16666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "bala_majhari_9.17",
      "item_name": "bala majhari",
      "item_quantity": 24,
      "item_unit_price": 9.166666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "bala_soto_7.92",
      "item_name": "bala soto",
      "item_quantity": 24,
      "item_unit_price": 7.916666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "barnis_200ml_66.00",
      "item_name": "barnis 200ml",
      "item_quantity": 16,
      "item_unit_price": 66.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "bedjoin_kalo_3_A_137.00",
      "item_name": "bedjoin kalo 3\" A",
      "item_quantity": 5,
      "item_unit_price": 137.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "bkh_shan_11.00",
      "item_name": "bkh shan",
      "item_quantity": 47,
      "item_unit_price": 11.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "boltu_10_ml_139.00",
      "item_name": "boltu 10 ml",
      "item_quantity": 13.509,
      "item_unit_price": 139.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_2_suta_5_160.00",
      "item_name": "boltu 2 suta. 5\"",
      "item_quantity": 3,
      "item_unit_price": 160.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_2.5_suta_5_160.00",
      "item_name": "boltu 2.5 suta. 5\"",
      "item_quantity": 3,
      "item_unit_price": 160.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_3_suta_1_140.00",
      "item_name": "boltu 3 suta 1\"",
      "item_quantity": 2,
      "item_unit_price": 140.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_3_suta_1.5_132.50",
      "item_name": "boltu 3 suta 1.5\"",
      "item_quantity": 2,
      "item_unit_price": 132.5,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_3_suta_2_118.00",
      "item_name": "boltu 3 suta 2\"",
      "item_quantity": 1.87,
      "item_unit_price": 118.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_3_suta_2.5_116.00",
      "item_name": "boltu 3 suta 2.5\"",
      "item_quantity": 2,
      "item_unit_price": 116.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_3_suta_3_4_118.00",
      "item_name": "boltu 3 suta 3\"-4\"",
      "item_quantity": 90.77425,
      "item_unit_price": 118.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_3_suta_5_111.00",
      "item_name": "boltu 3 suta 5\"",
      "item_quantity": 45.50125,
      "item_unit_price": 111.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_4_suta_2.5_112.00",
      "item_name": "boltu 4 suta 2.5\"",
      "item_quantity": 13.039,
      "item_unit_price": 112.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_4_suta_3,4,5,6_118.00",
      "item_name": "boltu 4 suta 3\", 4\", 5\", 6\"",
      "item_quantity": 68.77925,
      "item_unit_price": 118.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "boltu_4_suta_7,8_116.62",
      "item_name": "boltu 4 suta 7\", 8\"",
      "item_quantity": 9.318,
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
      "item_unit_price": 80.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "cakti_20_150.00",
      "item_name": "cakti 20",
      "item_quantity": 9,
      "item_unit_price": 150.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "cakti_cng_160.00",
      "item_name": "cakti cng",
      "item_quantity": 11.505,
      "item_unit_price": 160.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "1_pin_kata_138.89",
      "item_name": "1\" pin kata",
      "item_quantity": 2.4,
      "item_unit_price": 138.8888889,
      "item_unit_type": "kg"
    },
    {
      "item_id": "1_steel_kata_300.00",
      "item_name": "1\" steel kata",
      "item_quantity": 1,
      "item_unit_price": 300.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "1.5_steel_kata_255.00",
      "item_name": "1.5\" steel kata",
      "item_quantity": 1,
      "item_unit_price": 255.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "13_22_cover_99.00",
      "item_name": "13/22 cover",
      "item_quantity": 5,
      "item_unit_price": 99.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "2_al_tala_normal_5.00",
      "item_name": "2\" al tala normal",
      "item_quantity": 12,
      "item_unit_price": 5.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "2_al_tala_pitol_5.42",
      "item_name": "2\" al tala pitol",
      "item_quantity": 36,
      "item_unit_price": 5.416666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "2_aunch_rong_lal_11.67",
      "item_name": "2 aunch rong lal",
      "item_quantity": 12,
      "item_unit_price": 11.66666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "2_aunch_rong_sada_11.67",
      "item_name": "2 aunch rong sada",
      "item_quantity": 12,
      "item_unit_price": 11.66666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "2_ss_sitkani_21.67",
      "item_name": "2\" ss sitkani",
      "item_quantity": 24,
      "item_unit_price": 21.66666667,
      "item_unit_type": "piece"
    },
    {
      "item_id": "2.5_suta_boltu_1,2,2.5,3,4_140.00",
      "item_name": "2.5 suta boltu 1\", 2\", 2.5\", 3\", 4\"",
      "item_quantity": 8.568,
      "item_unit_price": 140.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "25_tar_138.00",
      "item_name": "25 tar",
      "item_quantity": 39.597,
      "item_unit_price": 138.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "25_tar_guna_136.00",
      "item_name": "25 tar guna",
      "item_quantity": 25,
      "item_unit_price": 136.0,
      "item_unit_type": "kg"
    },
    {
      "item_id": "3_k_band_mota_kobja_11.96",
      "item_name": "3\" k band mota kobja",
      "item_quantity": 13,
      "item_unit_price": 11.95833333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "3_4_pin_kata_138.89",
      "item_name": "3/4\" pin kata",
      "item_quantity": 1.95,
      "item_unit_price": 138.8888889,
      "item_unit_type": "kg"
    },
    {
      "item_id": "4_diamond_blade_75.00",
      "item_name": "4\" diamond blade",
      "item_quantity": 2,
      "item_unit_price": 75.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "4_entic_kobja_22.50",
      "item_name": "4\" entic kobja",
      "item_quantity": 31,
      "item_unit_price": 22.5,
      "item_unit_type": "piece"
    },
    {
      "item_id": "4_ss_handle_23.00",
      "item_name": "4\" ss handle",
      "item_quantity": 11,
      "item_unit_price": 23.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "5_diamond_blade_90.00",
      "item_name": "5\" diamond blade",
      "item_quantity": 3,
      "item_unit_price": 90.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "5_nokia_blade_90.00",
      "item_name": "5\" nokia blade",
      "item_quantity": 3,
      "item_unit_price": 90.0,
      "item_unit_type": "piece"
    },
    {
      "item_id": "6_rat_53.33",
      "item_name": "6\" rat",
      "item_quantity": 12,
      "item_unit_price": 53.33333333,
      "item_unit_type": "piece"
    },
    {
      "item_id": "8_kumir_shan_70.00",
      "item_name": "8\" kumir shan",
      "item_quantity": 3,
      "item_unit_price": 70.0,
      "item_unit_type": "piece"
    },
  ];
}
