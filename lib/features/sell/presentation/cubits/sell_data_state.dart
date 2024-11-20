part of 'sell_data_cubit.dart';

@immutable
sealed class SellDataState extends Equatable{}

final class SellDataInitial extends SellDataState {
  @override
  List<Object?> get props => [];
}

final class SellDataLoading extends SellDataState {
  @override
  List<Object?> get props => [];
}

final class SellDataSuccess extends SellDataState {
  final List<SellDataEntity> items;
  SellDataSuccess({required this.items});

  @override
  List<Object?> get props => [items];
}

final class SellDataError extends SellDataState {
  final String error;
  SellDataError(this.error);

  @override
  List<Object?> get props => [error];
}

final class AddSellDataSuccess extends SellDataState {
  final String successMsg;
  AddSellDataSuccess({required this.successMsg});

  @override
  List<Object?> get props => [successMsg];
}

final class AddSellDataError extends SellDataState {
  final String error;
  AddSellDataError(this.error);

  @override
  List<Object?> get props => [error];
}