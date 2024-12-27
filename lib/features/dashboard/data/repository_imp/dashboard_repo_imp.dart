import 'package:dartz/dartz.dart';

import '../../domain/entity/dashboard_entity.dart';

import '../../domain/entity/merge_request_entity.dart';
import '../../domain/repository/dashboard_repo.dart';
import '../data_source/dashboard_data_source.dart';
import '../model/dashboard_model.dart';

class DashboardRepoImp implements DashboardRepo {
  final DashboardDataSource dashboardDataSource;
  DashboardRepoImp(this.dashboardDataSource);

  @override
  Future<Either<String, List<DashboardEntity>>> fetchData() async {
    try {
      final result = await dashboardDataSource.fetchData();
      return right(
        result.map((e) => DashboardModel.fromJson(e).toEntity()).toList(),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> mergeItem(
      MergeRequestEntity mergeRequestEntity) async {
    try {
      final mergingItemId = mergeRequestEntity.mergingItemId;
      final intoItemId = mergeRequestEntity.intoItemId;
      final intoItemQuantity = mergeRequestEntity.intoItemNewQuantity;
      final intoItemUnitPrice = mergeRequestEntity.intoItemNewUnitPrice;
      await dashboardDataSource.updateItem(
        itemId: intoItemId,
        newQuantity: intoItemQuantity,
        newUnitPrice: intoItemUnitPrice,
      );
      if (await dashboardDataSource.doesItemExist(itemId: mergingItemId)) {
        await dashboardDataSource.deleteItem(mergingItemId);
      }
      return right('Item merged successfully');
    } catch (e) {
      return left(e.toString());
    }
  }
}
