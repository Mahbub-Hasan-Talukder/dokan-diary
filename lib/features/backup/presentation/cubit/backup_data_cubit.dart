import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/backup_use_case/backup_use_case.dart';

part 'backup_data_state.dart';

class BackupDataCubit extends Cubit<BackupDataState> {
  BackupDataCubit(this.backUpUseCase) : super(UploadDataInitial());
  BackUpUseCase backUpUseCase;

  void uploadData() async {
    emit(UploadDataLoading());
    final result = await backUpUseCase.uploadDataUseCase();
    result.fold((successMsg) {
      emit(UploadDataSuccess(successMsg));
    }, (error) {
      emit(UploadDataFailed(error));
    });
  }

  void restoreData() async {
    emit(RestoreDataLoading());
    final result = await backUpUseCase.uploadDataUseCase();
    result.fold((successMsg) {
      emit(RestoreDataSuccess(successMsg));
    }, (error) {
      emit(RestoreDataFailed(error));
    });
  }
}
