import 'package:diary/features/backup/data/data_source/remote/data_source.dart';
import 'package:diary/features/backup/data/data_source/remote/firestore_imp.dart';
import 'package:diary/features/backup/data/repository_imp/backup_repo_imp.dart';
import 'package:diary/features/backup/domain/backup_repo/backup_repository.dart';
import 'package:diary/features/backup/domain/backup_use_case/backup_use_case.dart';
import 'package:diary/features/backup/presentation/cubit/backup_data_cubit.dart';
import 'package:diary/features/records/data/data_source/data_source.dart';
import 'package:diary/features/records/data/data_source/data_source_imp.dart';
import 'package:diary/features/records/data/repository_imp/RecordRepositoryImp.dart';
import 'package:diary/features/records/domain/repository/records_repository.dart';
import 'package:diary/features/records/domain/use_cases/record_use_cases.dart';
import 'package:diary/features/records/presentation/bloc/day_wise_records/day_wise_cubit.dart';
import 'package:diary/features/sell/data/data_source/data_source.dart';
import 'package:diary/features/sell/data/data_source/sell_data_source_imp.dart';
import 'package:diary/features/sell/data/repository_imp/sell_data_repo_imp.dart';
import 'package:diary/features/sell/domain/repository/fetch_sell_data_repo.dart';
import 'package:diary/features/sell/domain/use_cases/sell_data_use_case.dart';
import 'package:diary/features/sell/presentation/cubits/fetch_items/fetch_bought_items_cubit.dart';
import 'package:diary/features/sell/presentation/cubits/sell_items/sell_data_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../features/add_note/data/data_source/local_data_source/note_local_data_source.dart';
import '../../features/add_note/data/data_source/local_data_source/note_local_data_source_imp.dart';
import '../../features/add_note/data/data_source/remote_data_source/note_remote_data_source.dart';
import '../../features/add_note/data/data_source/remote_data_source/remote_note_data_source_imp.dart';
import '../../features/add_note/data/repository_imp/note_repository_imp.dart';
import '../../features/add_note/domain/repositoy/note_repository.dart';
import '../../features/add_note/domain/usecase/note_usecase.dart';
import '../../features/add_note/presentation/bloc/add_note/add_note_cubit.dart';
import '../../features/add_note/presentation/bloc/delete_note/delete_note_cubit.dart';
import '../../features/add_note/presentation/bloc/get_note/get_note_cubit.dart';
import '../../features/add_note/presentation/bloc/update_note/update_note_cubit.dart';
import '../../features/backup/data/data_source/local/local_data_source.dart';
import '../../features/backup/data/data_source/local/sqLite_imp.dart';
import '../../features/buy/data/data_source/data_source.dart';
import '../../features/buy/data/data_source/data_source_imp.dart';
import '../../features/buy/data/repository_imp/fetch_item_repo_imp.dart';
import '../../features/buy/domain/repository/fetch_item_repo.dart';
import '../../features/buy/domain/use_cases/fetch_item_use_case.dart';
import '../../features/buy/presentation/cubits/fetch_items/fetch_item_cubit.dart';
import '../../features/dashboard/data/data_source/dashboard_data_source.dart';
import '../../features/dashboard/data/data_source/dashboard_data_source_imp.dart';
import '../../features/dashboard/data/repository_imp/dashboard_repo_imp.dart';
import '../../features/dashboard/domain/repository/dashboard_repo.dart';
import '../../features/dashboard/domain/use_case/dashboard_usecase.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/records/presentation/bloc/item_wise_records/item_wise_cubit.dart';
import '../../features/sell/presentation/cubits/undo_record/undo_record_cubit.dart';
import '../database/database_helper.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  //cubits
  getIt.registerLazySingleton(() => FetchItemCubit(getIt.call()));
  getIt.registerFactory(() => SellDataCubit(getIt.call()));
  getIt.registerFactory(() => FetchBoughtItemsCubit(getIt.call()));
  getIt.registerFactory(() => BackupDataCubit(getIt.call()));
  getIt.registerFactory(() => UndoRecordCubit(getIt.call()));
  getIt.registerFactory(() => DayWiseCubit(getIt.call()));
  getIt.registerFactory(() => ItemWiseCubit(getIt.call()));
  getIt.registerFactory(() => DashboardCubit(getIt.call()));
  getIt.registerFactory(() => GetNoteCubit(getIt.call()));
  getIt.registerFactory(() => UpdateNoteCubit(getIt.call()));
  getIt.registerFactory(() => AddNoteCubit(getIt.call()));
  getIt.registerFactory(() => DeleteNoteCubit(getIt.call()));
  //use case
  getIt.registerLazySingleton<FetchItemUseCase>(
      () => FetchItemUseCase(getIt.call()));
  getIt.registerLazySingleton<SellDataUseCase>(
      () => SellDataUseCase(getIt.call()));
  getIt.registerLazySingleton<BackUpUseCase>(() => BackUpUseCase(getIt.call()));
  getIt.registerLazySingleton<RecordsUseCases>(
      () => RecordsUseCases(getIt.call()));
  getIt.registerLazySingleton<DashboardUsecase>(
      () => DashboardUsecase(getIt.call()));
  getIt.registerLazySingleton<NoteUsecase>(() => NoteUsecase(getIt.call()));

  //repository
  getIt.registerLazySingleton<FetchItemRepo>(
      () => FetchItemRepoImp(getIt.call()));
  getIt
      .registerLazySingleton<SellDataRepo>(() => SellDataRepoImp(getIt.call()));
  getIt.registerLazySingleton<BackupRepository>(
      () => BackupRepoImp(getIt.call()));
  getIt.registerLazySingleton<RecordsRepository>(
      () => RecordsRepositoryImp(getIt.call()));
  getIt.registerLazySingleton<DashboardRepo>(
      () => DashboardRepoImp(getIt.call()));
  getIt.registerLazySingleton<NoteRepository>(
      () => NoteRepositoryImp(getIt.call(), getIt.call()));

  //data source
  getIt.registerLazySingleton<FetchItemDataSource>(
      () => FetchItemDataSourceImpl());
  getIt.registerLazySingleton<SellDataSource>(() => SellDataSourceImp());
  getIt.registerLazySingleton<BackupDataSource>(() => FireStoreImp());
  getIt.registerLazySingleton<BackupLocalDataSource>(() => SqLiteImp());
  getIt.registerLazySingleton<RecordsDataSource>(() => RecordsDataSourceImp());
  getIt.registerLazySingleton<DashboardDataSource>(
      () => DashboardDataSourceImp());
  getIt.registerLazySingleton<RemoteNoteDataSource>(
      () => RemoteNoteDataSourceImp());
  getIt.registerLazySingleton<NoteLocalDataSource>(
      () => NoteLocalDataSourceImp());
}
