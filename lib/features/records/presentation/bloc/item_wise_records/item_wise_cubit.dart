import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/item_wise_entity.dart';
import '../../../domain/use_cases/record_use_cases.dart';

part 'item_wise_state.dart';

class ItemWiseCubit extends Cubit<ItemWiseState> {
  ItemWiseCubit(this._recordsUseCases) : super(ItemWiseInitial());
  final RecordsUseCases _recordsUseCases;

  void fetchItemWiseRecords({String? startDate, String? endDate}) async {
    emit(ItemWiseLoading());
    final result = await _recordsUseCases.fetchItemWiseData(
      startDate: startDate,
      endDate: endDate,
    );

    result.fold((records) {
      emit(ItemWiseSuccess(records));
    }, (error) {
      emit(ItemWiseError(error));
    });
  }
}
