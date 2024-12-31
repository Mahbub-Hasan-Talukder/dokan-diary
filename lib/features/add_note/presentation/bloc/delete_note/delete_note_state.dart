import 'package:equatable/equatable.dart';

abstract class DeleteNoteState extends Equatable {
  const DeleteNoteState();

  @override
  List<Object?> get props => [];
}

class DeleteNoteInitial extends DeleteNoteState {}

class DeleteNoteLoading extends DeleteNoteState {}

class DeleteNoteSuccess extends DeleteNoteState {
  final String message;

  const DeleteNoteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteNoteFailure extends DeleteNoteState {
  final String message;

  const DeleteNoteFailure(this.message);

  @override
  List<Object?> get props => [message];
}
