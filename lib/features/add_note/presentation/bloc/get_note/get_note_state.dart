import 'package:equatable/equatable.dart';

import '../../../domain/entity/note_entity.dart';

abstract class GetNoteState extends Equatable {
  const GetNoteState();

  @override
  List<Object?> get props => [];
}

class GetNoteInitial extends GetNoteState {}

class GetNoteLoading extends GetNoteState {}

class GetNoteSuccess extends GetNoteState {
  final List<NoteEntity> notes;

  const GetNoteSuccess(this.notes);

  @override
  List<Object?> get props => [notes];
}

class GetNoteFailure extends GetNoteState {
  final String message;

  const GetNoteFailure(this.message);

  @override
  List<Object?> get props => [message];
}
