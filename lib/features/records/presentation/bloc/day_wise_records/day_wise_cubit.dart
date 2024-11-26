import 'package:bloc/bloc.dart';
import 'package:diary/features/records/domain/entities/day_wise_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/use_cases/record_use_cases.dart';

part 'day_wise_state.dart';

class DayWiseCubit extends Cubit<DayWiseState> {
  DayWiseCubit(this._recordsUseCases) : super(DayWiseInitial());
  final RecordsUseCases _recordsUseCases;

  void fetchDateWiseRecords({String? startDate, String? endDate}) async {
    emit(DayWiseLoading());
    final result = await _recordsUseCases.fetchDayWiseData();

    result.fold((records) {
      emit(DayWiseSuccess(records));
    }, (error) {
      emit(DayWiseError(error));
    });
  }
}
