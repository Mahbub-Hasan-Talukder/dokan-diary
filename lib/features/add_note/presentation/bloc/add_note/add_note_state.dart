import 'package:equatable/equatable.dart';

class AddNoteState extends Equatable {
  const AddNoteState();

  @override
  List<Object?> get props => [];
}

class AddNoteInitial extends AddNoteState {}

class AddNoteLoading extends AddNoteState {}

class AddNoteSuccess extends AddNoteState {
  final String message;

  const AddNoteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddNoteFailure extends AddNoteState {
  final String message;

  const AddNoteFailure(this.message);

  @override
  List<Object?> get props => [message];
}
