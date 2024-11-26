part of 'undo_record_cubit.dart';

sealed class UndoRecordState extends Equatable {
  const UndoRecordState();
}

final class UndoRecordInitial extends UndoRecordState {
  @override
  List<Object> get props => [];
}

final class UndoRecordLoading extends UndoRecordState {
  @override
  List<Object> get props => [];
}

final class UndoRecordSuccess extends UndoRecordState {
  final String message;

  const UndoRecordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class UndoRecordError extends UndoRecordState {
  final String message;

  const UndoRecordError(this.message);

  @override
  List<Object> get props => [message];
}
