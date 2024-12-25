import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  Future<void> fetchData({DateTime? startDate, DateTime? endDate}) async {
    try {
      emit(DashboardLoading());
      // TODO: Implement your data fetching logic here
      emit(DashboardSuccess([])); // Replace [] with your actual data
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
