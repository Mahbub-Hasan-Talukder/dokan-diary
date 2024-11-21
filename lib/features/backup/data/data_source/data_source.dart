import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class BackupDataSource{
  Future<void> upload(List<Map<String,dynamic>> items);
  Future<QuerySnapshot<Map<String,dynamic>>> restore(String tableName);
  Future<List<Map<String, dynamic>>> fetchLocalData(String tableName);
}