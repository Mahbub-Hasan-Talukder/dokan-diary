import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BackupLocalDataSource {
  Future<List<Map<String, dynamic>>> fetchLocalData(String tableName);
  Future<void> restoreItemsTable(QuerySnapshot<Map<String, dynamic>> snapshots);
  Future<void> restoreSalesTable(
      QuerySnapshot<Map<String, dynamic>> snapshotsSales,
      QuerySnapshot<Map<String, dynamic>> snapshotsItems);
  Future<void> exportTablesToJson();
}
