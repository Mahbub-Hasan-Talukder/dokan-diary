part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final List<DashboardEntity> data;
  DashboardSuccess(this.data);
  @override
  List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}

class ItemMergeLoading extends DashboardState {}

class ItemMergeSuccess extends DashboardState {
  final String message;
  ItemMergeSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ItemMergeError extends DashboardState {
  final String message;
  ItemMergeError(this.message);
  @override
  List<Object?> get props => [message];
}
