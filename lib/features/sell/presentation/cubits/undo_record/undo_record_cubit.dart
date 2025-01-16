import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/use_cases/sell_data_use_case.dart';

part 'undo_record_state.dart';

class UndoRecordCubit extends Cubit<UndoRecordState> {
  UndoRecordCubit(this.sellDataUseCase) : super(UndoRecordInitial());
  final SellDataUseCase sellDataUseCase;

  void undoSell({
    required int saleId,
    required String itemId,
    required double quantitySold,
  }) async {
    emit(UndoRecordLoading());
    final result = await sellDataUseCase.undoSell(
      saleId: saleId,
      quantitySold: quantitySold,
      itemId: itemId,
    );
    result.fold((message) {
      emit(UndoRecordSuccess(message));
    }, (error) {
      emit(UndoRecordError(error));
    });
  }
}
