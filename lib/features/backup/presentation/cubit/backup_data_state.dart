part of 'backup_data_cubit.dart';

sealed class BackupDataState extends Equatable {
  const BackupDataState();
}

final class UploadDataInitial extends BackupDataState {
  @override
  List<Object> get props => [];
}

final class UploadDataLoading extends BackupDataState {
  @override
  List<Object> get props => [];
}

final class UploadDataSuccess extends BackupDataState {
  final String successMsg;
  UploadDataSuccess(this.successMsg);
  @override
  List<Object> get props => [successMsg];
}

final class UploadDataFailed extends BackupDataState {
  final String error;
  UploadDataFailed(this.error);
  @override
  List<Object> get props => [error];
}

final class RestoreDataLoading extends BackupDataState {
  @override
  List<Object> get props => [];
}

final class RestoreDataSuccess extends BackupDataState {
  final String successMsg;
  RestoreDataSuccess(this.successMsg);
  @override
  List<Object> get props => [successMsg];
}

final class RestoreDataFailed extends BackupDataState {
  final String error;
  RestoreDataFailed(this.error);
  @override
  List<Object> get props => [error];
}

//device backup
final class SaveToDeviceLoading extends BackupDataState {
  @override
  List<Object> get props => [];
}

final class SaveToDeviceSuccess extends BackupDataState {
  final String successMsg;
  const SaveToDeviceSuccess(this.successMsg);
  @override
  List<Object> get props => [successMsg];
}

final class SaveToDeviceFailed extends BackupDataState {
  final String error;
  const SaveToDeviceFailed(this.error);
  @override
  List<Object> get props => [error];
}

final class FetchFromDeviceLoading extends BackupDataState {
  @override
  List<Object> get props => [];
}

final class FetchFromDeviceSuccess extends BackupDataState {
  final String successMsg;
  const FetchFromDeviceSuccess(this.successMsg);
  @override
  List<Object> get props => [successMsg];
}

final class FetchFromDeviceFailed extends BackupDataState {
  final String error;
  const FetchFromDeviceFailed(this.error);
  @override
  List<Object> get props => [error];
}
