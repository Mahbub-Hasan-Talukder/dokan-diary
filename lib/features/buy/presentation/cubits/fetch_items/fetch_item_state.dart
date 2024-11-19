part of 'fetch_item_cubit.dart';

sealed class FetchItemState extends Equatable {
  const FetchItemState();

  @override
  List<Object> get props => [];
}

final class FetchItemInitial extends FetchItemState {}

final class FetchItemLoading extends FetchItemState {}

final class FetchItemSuccess extends FetchItemState{
  const FetchItemSuccess({required this.items});
  final List<ItemEntity> items;

  @override
  List<Object> get props => [items];
}

final class FetchItemError extends FetchItemState {
  const FetchItemError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}


final class AddItemSuccess extends FetchItemState{
  const AddItemSuccess({required this.success});
  final String success;

  @override
  List<Object> get props => [success];
}

final class AddItemError extends FetchItemState {
  const AddItemError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

final class DeleteItemSuccess extends FetchItemState{
  const DeleteItemSuccess({required this.success});
  final String success;

  @override
  List<Object> get props => [success];
}

final class DeleteItemError extends FetchItemState {
  const DeleteItemError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
