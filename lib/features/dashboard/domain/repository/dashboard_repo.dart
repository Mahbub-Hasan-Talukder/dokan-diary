import 'package:dartz/dartz.dart';

import '../entity/dashboard_entity.dart';
import '../entity/merge_request_entity.dart';

abstract class DashboardRepo {
  Future<Either<String, List<DashboardEntity>>> fetchData();
  Future<Either<String, String>> mergeItem(
    MergeRequestEntity mergeRequestEntity,
  );
}
