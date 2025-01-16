import 'package:equatable/equatable.dart';

class UpdateNoteState extends Equatable {
  const UpdateNoteState();

  @override
  List<Object> get props => [];
}

class UpdateNoteInitial extends UpdateNoteState {}

class UpdateNoteLoading extends UpdateNoteState {}

class UpdateNoteSuccess extends UpdateNoteState {
  final String message;
  const UpdateNoteSuccess(this.message);
}

class UpdateNoteFailure extends UpdateNoteState {
  final String message;
  const UpdateNoteFailure(this.message);
}
