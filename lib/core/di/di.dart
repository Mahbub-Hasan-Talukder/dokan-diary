
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

  //use case
  getIt.registerLazySingleton<FetchItemUseCase>(()=>FetchItemUseCase(getIt.call()));

  //repository
  getIt.registerLazySingleton<FetchItemRepo>(()=>FetchItemRepoImp(getIt.call()));

  //data source
  getIt.registerLazySingleton<FetchItemDataSource>(()=>FetchItemDataSourceImpl());

}