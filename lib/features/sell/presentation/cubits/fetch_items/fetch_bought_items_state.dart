part of 'fetch_bought_items_cubit.dart';

@immutable
sealed class FetchBoughtItemsState {}

final class FetchBoughtItemsInitial extends FetchBoughtItemsState {}

final class FetchItemDone extends FetchBoughtItemsState {
  final List<FetchItemEntity> entityList;
  FetchItemDone({required this.entityList});

  @override
  List<Object?> get props => [entityList];
}

final class FetchItemFailed extends FetchBoughtItemsState {
  final String error;
  FetchItemFailed(this.error);

  @override
  List<Object?> get props => [error];
}