import 'package:bloc/bloc.dart';
import 'package:diary/features/buy/domain/entities/add_request_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/item_entity.dart';
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
    String id = "${itemName}_${unitPrice.floorToDouble()}";
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

  void deleteItem({required String itemName, required String price})async{
    String itemId = "${itemName}_$price";
    final result = await fetchItemUseCase.delete(itemId: itemId);
    result.fold((success){
      emit(DeleteItemSuccess(success: success));
    }, (error){
      emit(DeleteItemError(error));
    });
  }
}
