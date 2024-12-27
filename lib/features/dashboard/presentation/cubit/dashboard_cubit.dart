import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/dashboard_entity.dart';
import '../../domain/use_case/dashboard_usecase.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.dashboardUsecase) : super(DashboardInitial());
  final DashboardUsecase dashboardUsecase;

  Future<void> fetchData({DateTime? startDate, DateTime? endDate}) async {
    try {
      emit(DashboardLoading());
      final result = await dashboardUsecase.fetchData();
      result.fold(
        (l) => emit(DashboardError(l)),
        (r) {
          emit(DashboardSuccess(r));
        },
      );
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
