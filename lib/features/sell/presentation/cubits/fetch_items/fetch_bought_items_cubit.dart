import 'package:bloc/bloc.dart';
import 'package:diary/features/sell/domain/use_cases/sell_data_use_case.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/fetch_item_entity.dart';

part 'fetch_bought_items_state.dart';

class FetchBoughtItemsCubit extends Cubit<FetchBoughtItemsState> {
  FetchBoughtItemsCubit(this.sellDataUseCase) : super(FetchBoughtItemsInitial());

  final SellDataUseCase sellDataUseCase;

  void fetchItems() async {
    final result = await sellDataUseCase.fetchItems();
    result.fold((items) {
      emit(FetchItemDone(entityList: items));
    }, (error) {
      emit(FetchItemFailed(error));
    });
  }
}
