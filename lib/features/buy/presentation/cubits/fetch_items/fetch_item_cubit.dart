import 'package:bloc/bloc.dart';
import 'package:diary/features/buy/domain/entities/add_request_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/item_entity.dart';
import '../../../domain/entities/update_request_entity.dart';
import '../../../domain/use_cases/fetch_item_use_case.dart';

part 'fetch_item_state.dart';

class FetchItemCubit extends Cubit<FetchItemState> {
  FetchItemCubit(this.fetchItemUseCase) : super(FetchItemInitial());
  FetchItemUseCase fetchItemUseCase;

  void fetchItems() async {
    emit(FetchItemLoading());

    final result = await fetchItemUseCase.call();
    result.fold((items) {
      emit(FetchItemSuccess(items: items));
    }, (error) {
      emit(FetchItemError(error));
    });
  }

  void addItems({
    required String itemName,
    required String unitType,
    required double unitPrice,
    required double itemQuantity,
  }) async {
    String id = "${itemName}_${unitPrice.toStringAsFixed(2)}";
    // String id = itemName;

    AddRequestEntity entity = AddRequestEntity(
      id: id,
      itemName: itemName,
      quantity: itemQuantity,
      unitPrice: unitPrice,
      unitType: unitType,
    );
    final result = await fetchItemUseCase.add(entity: entity);
    result.fold((success) {
      emit(AddItemSuccess(success: success));
    }, (error) {
      emit(AddItemError(error));
    });
  }

  void deleteItem({required String itemId, String? price}) async {
    final result = await fetchItemUseCase.delete(itemId: itemId);
    result.fold((success) {
      emit(DeleteItemSuccess(success: success));
    }, (error) {
      emit(DeleteItemError(error));
    });
  }

  void updateItem({
    required String itemId,
    required String itemOldId,
    required double unitPrice,
    required double quantity,
    required String itemName,
    required String unitType,
  }) async {
    UpdateRequestEntity entity = UpdateRequestEntity(
      itemId: itemId,
      itemOldId: itemOldId,
      unitPrice: unitPrice,
      quantity: quantity,
      itemName: itemName,
      unitType: unitType,
    );
    final result = await fetchItemUseCase.update(entity: entity);
    result.fold((items) {
      emit(FetchItemSuccess(items: items));
    }, (error) {
      emit(FetchItemError(error));
    });
  }
}
