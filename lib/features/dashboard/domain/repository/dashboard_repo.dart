import 'package:dartz/dartz.dart';

import '../entity/dashboard_entity.dart';

abstract class DashboardRepo {
  Future<Either<String, List<DashboardEntity>>> fetchData();
}
