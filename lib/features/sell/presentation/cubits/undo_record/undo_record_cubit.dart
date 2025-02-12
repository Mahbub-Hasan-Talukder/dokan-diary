import 'package:bloc/bloc.dart';
import 'package:diary/features/sell/presentation/cubits/sell_items/sell_data_cubit.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/di/di.dart';
import '../../../domain/entities/sell_data_entity.dart';
import '../../../domain/use_cases/sell_data_use_case.dart';

part 'undo_record_state.dart';

class UndoRecordCubit extends Cubit<UndoRecordState> {
  UndoRecordCubit(this.sellDataUseCase) : super(UndoRecordInitial());
  final SellDataUseCase sellDataUseCase;

  void undoSell({
    required int saleId,
    required String itemId,
    required double quantitySold,
    required DateTime date,
  }) async {
    emit(UndoRecordLoading());
    final result = await sellDataUseCase.undoSell(
      saleId: saleId,
      quantitySold: quantitySold,
      itemId: itemId,
      date: date,
    );
    result.fold((data) {
      emit(UndoRecordSuccess(data));
    }, (error) {
      emit(UndoRecordError(error));
    });
  }
}
