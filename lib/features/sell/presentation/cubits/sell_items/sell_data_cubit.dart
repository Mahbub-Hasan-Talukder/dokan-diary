import 'package:bloc/bloc.dart';
import 'package:diary/core/services/date_time_format.dart';
import 'package:diary/features/buy/domain/entities/add_request_entity.dart';
import 'package:diary/features/sell/domain/entities/fetch_item_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/sell_data_entity.dart';
import '../../../domain/entities/sell_request_entity.dart';
import '../../../domain/use_cases/sell_data_use_case.dart';

part 'sell_data_state.dart';

class SellDataCubit extends Cubit<SellDataState> {
  SellDataCubit(this.sellDataUseCase) : super(SellDataInitial());
  SellDataUseCase sellDataUseCase;

  void fetchSellData({required DateTime date}) async {
    emit(SellDataLoading());
    String id = DateTimeFormat.getYMD(date);
    final result = await sellDataUseCase.fetchSellData(date: id);
    result.fold((items) {
      emit(SellDataSuccess(items: items));
    }, (error) {
      emit(SellDataError(error));
    });
  }

  void addSellData({required SellRequestEntity reqEntity}) async {
    emit(SellDataLoading());

    final result = await sellDataUseCase.addSellData(reqEntity: reqEntity);
    result.fold((msg) {
      emit(AddSellDataSuccess(successMsg: msg));
    }, (error) {
      emit(AddSellDataError(error));
    });
  }


}
