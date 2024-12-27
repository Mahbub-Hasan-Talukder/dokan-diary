import 'package:dartz/dartz.dart';

import '../../domain/entity/dashboard_entity.dart';

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
}
