import 'package:dartz/dartz.dart';
import 'package:diary/features/backup/domain/backup_repo/backup_repository.dart';

class BackUpUseCase{
  BackupRepository backupRepository;
  BackUpUseCase(this.backupRepository);
  Future<Either<String,String>> uploadDataUseCase()async{
    return await backupRepository.uploadData();
  }
  Future<Either<String,String>> restoreDataUseCase()async{
    return await backupRepository.restoreData();
  }
}