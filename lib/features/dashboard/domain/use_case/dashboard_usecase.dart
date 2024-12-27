import 'package:dartz/dartz.dart';

import '../entity/dashboard_entity.dart';
import '../repository/dashboard_repo.dart';

class DashboardUsecase {
  final DashboardRepo dashboardRepo;
  DashboardUsecase(this.dashboardRepo);
  Future<Either<String, List<DashboardEntity>>> fetchData() async {
    final result = await dashboardRepo.fetchData();
    return result;
  }
}
