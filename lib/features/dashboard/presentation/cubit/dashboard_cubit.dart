import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/dashboard_entity.dart';
import '../../domain/entity/merge_request_entity.dart';
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

  Future<void> mergeItem(
    DashboardEntity mergingEntity,
    DashboardEntity intoEntity,
  ) async {
    emit(ItemMergeLoading());
    double mergingQuantity = mergingEntity.quantity ?? 0;
    double mergingItemUnitPrice = mergingEntity.unitPrice ?? 0;
    double mergingItemTotalPrice = mergingItemUnitPrice * mergingQuantity;

    double intoQuantity = intoEntity.quantity ?? 0;
    double intoUnitPrice = intoEntity.unitPrice ?? 0;
    double intoAllPrice = intoQuantity * intoUnitPrice + mergingItemTotalPrice;
    double intoNewItemQuantity = (intoEntity.quantity ?? 0) + mergingQuantity;
    intoNewItemQuantity = (intoNewItemQuantity == 0 ? 1 : intoNewItemQuantity);
    double intoNewItemPrice = intoAllPrice / intoNewItemQuantity;

    final result = await dashboardUsecase.mergeItem(
      MergeRequestEntity(
        mergingItemId: mergingEntity.id ?? 'no id',
        intoItemId: intoEntity.id ?? 'no id',
        intoItemNewQuantity: intoNewItemQuantity,
        intoItemNewUnitPrice: intoNewItemPrice,
      ),
    );
    result.fold(
      (l) => emit(ItemMergeError(l)),
      (r) => emit(ItemMergeSuccess(r)),
    );
  }
}
