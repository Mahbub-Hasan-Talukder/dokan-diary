import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:diary/features/backup/data/data_source/local/local_data_source.dart';
import 'package:diary/features/backup/data/data_source/local/sqLite_imp.dart';
import 'package:diary/features/backup/data/data_source/remote/data_source.dart';
import 'package:diary/features/backup/domain/backup_repo/backup_repository.dart';

import '../../../../core/di/di.dart';

class BackupRepoImp implements BackupRepository {
  BackupDataSource backupDataSource;
  BackupRepoImp(this.backupDataSource);

  @override
  Future<Either<String, String>> restoreData() async {
    try {
      final localDataSource = getIt.get<BackupLocalDataSource>();
      final itemsTableData = await backupDataSource.restore('Items');
      await localDataSource.restoreItemsTable(itemsTableData);

      final salesTableData = await backupDataSource.restore('Sales');
      await localDataSource.restoreSalesTable(salesTableData);

      return Left('Success');
    } catch (e) {
      Right(e.toString());
    }
    return Left('Success');
  }

  @override
  Future<Either<String, String>> uploadData() async {
    final sqLiteDataSource = getIt.get<BackupLocalDataSource>();
    try {
      await _saveToDevice();
      final data = await sqLiteDataSource.fetchLocalData('Items');
      await backupDataSource.upload(data, 'Items');
      final data1 = await sqLiteDataSource.fetchLocalData('Sales');
      print('dbg $data1');
      await backupDataSource.upload(data1, 'Sales');
      return Left('Success');
    } catch (e) {
      Right(e.toString());
    }
    return Left('Success');
  }

  Future<void> _saveToDevice() async {
    try {
      final localDataSource = getIt.get<BackupLocalDataSource>();
      // List<Map<String, dynamic>> itemsJson =
      //     await localDataSource.fetchLocalData('Items');
      // List<Map<String, dynamic>> salesJson =
      //     await localDataSource.fetchLocalData('Sales');
      await localDataSource.exportTablesToJson();

      return;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
