import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:diary/features/backup/data/data_source/data_source.dart';
import 'package:diary/features/backup/domain/backup_repo/backup_repository.dart';

class BackupRepoImp implements BackupRepository{
  BackupDataSource backupDataSource;
  BackupRepoImp(this.backupDataSource);

  @override
  Future<Either<String, String>> restoreData()async {
    try{
      final data = await backupDataSource.restore('Items');
      return Left('Success');
    }catch(e){
      Right(e.toString());
    }
    return Left('Success');
  }

  @override
  Future<Either<String, String>> uploadData() async{
    try{

      final data = await backupDataSource.fetchLocalData('Items');
      await backupDataSource.upload(data);
      // print(data);
      return Left('Success');
    }catch(e){
      Right(e.toString());
    }
    return Left('Success');
  }
}