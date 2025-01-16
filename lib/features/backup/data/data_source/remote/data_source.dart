import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class BackupDataSource{
  Future<void> upload(List<Map<String,dynamic>> items, String tableName);
  Future<QuerySnapshot<Map<String,dynamic>>> restore(String tableName);

}