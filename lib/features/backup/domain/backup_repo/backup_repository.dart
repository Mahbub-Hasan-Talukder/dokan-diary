import 'package:dartz/dartz.dart';

abstract class BackupRepository {
  Future<Either<String, String>> uploadData();
  Future<Either<String, String>> restoreData();
  // Future<Either<String, String>> saveToDevice();
}
