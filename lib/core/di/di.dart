
import 'package:diary/features/sell/data/data_source/data_source.dart';
import 'package:diary/features/sell/data/data_source/sell_data_source_imp.dart';
import 'package:diary/features/sell/data/repository_imp/sell_data_repo_imp.dart';
import 'package:diary/features/sell/domain/repository/fetch_sell_data_repo.dart';
import 'package:diary/features/sell/domain/use_cases/sell_data_use_case.dart';
import 'package:diary/features/sell/presentation/cubits/sell_data_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../features/buy/data/data_source/data_source.dart';
import '../../features/buy/data/data_source/data_source_imp.dart';
import '../../features/buy/data/repository_imp/fetch_item_repo_imp.dart';
import '../../features/buy/domain/repository/fetch_item_repo.dart';
import '../../features/buy/domain/use_cases/fetch_item_use_case.dart';
import '../../features/buy/presentation/cubits/fetch_items/fetch_item_cubit.dart';
import '../database/database_helper.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  
  //cubits
  getIt.registerFactory(()=>FetchItemCubit(getIt.call()));
  getIt.registerFactory(()=>SellDataCubit(getIt.call()));

  //use case
  getIt.registerLazySingleton<FetchItemUseCase>(()=>FetchItemUseCase(getIt.call()));
  getIt.registerLazySingleton<SellDataUseCase>(()=>SellDataUseCase(getIt.call()));

  //repository
  getIt.registerLazySingleton<FetchItemRepo>(()=>FetchItemRepoImp(getIt.call()));
  getIt.registerLazySingleton<SellDataRepo>(()=>SellDataRepoImp(getIt.call()));
  //data source
  getIt.registerLazySingleton<FetchItemDataSource>(()=>FetchItemDataSourceImpl());
  getIt.registerLazySingleton<SellDataSource>(()=>SellDataSourceImp());
}