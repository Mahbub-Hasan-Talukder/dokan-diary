part of 'day_wise_cubit.dart';

sealed class DayWiseState extends Equatable {
  const DayWiseState();
}

final class DayWiseInitial extends DayWiseState {
  @override
  List<Object> get props => [];
}

final class DayWiseLoading extends DayWiseState {
  @override
  List<Object> get props => [];
}

final class DayWiseSuccess extends DayWiseState {
  const DayWiseSuccess(this.records);
  final List<DayWiseEntity> records;
  @override
  List<Object> get props => [];
}

final class DayWiseError extends DayWiseState {
  DayWiseError(this.error);
  final String error;
  @override
  List<Object> get props => [];
}



