part of 'item_wise_cubit.dart';

sealed class ItemWiseState extends Equatable {
  const ItemWiseState();
}

final class ItemWiseInitial extends ItemWiseState {
  @override
  List<Object> get props => [];
}


final class ItemWiseLoading extends ItemWiseState {
  @override
  List<Object> get props => [];
}

final class ItemWiseSuccess extends ItemWiseState {
  const ItemWiseSuccess(this.records);
  final List<ItemWiseEntity> records;
  @override
  List<Object> get props => [];
}

final class ItemWiseError extends ItemWiseState {
  const ItemWiseError(this.error);
  final String error;
  @override
  List<Object> get props => [];
}



