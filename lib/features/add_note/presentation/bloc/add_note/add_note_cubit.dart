import 'package:diary/features/add_note/domain/usecase/note_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/note_entity.dart';
import 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  final NoteUsecase noteUsecase;
  AddNoteCubit(this.noteUsecase) : super(AddNoteInitial());

  Future<void> addNote(NoteEntity note) async {
    emit(AddNoteLoading());
    final result = await noteUsecase.addNote(note);
    result.fold((l) => emit(AddNoteFailure(l)), (r) => emit(AddNoteSuccess(r)));
  }

  // Future<void> getNotes() async {
  //   emit(AddNoteLoading());
  //   final result = await noteUsecase.getNotes();
  // }

  // Future<void> deleteNote(String id) async {
  //   emit(AddNoteLoading());
  //   final result = await noteUsecase.deleteNote(id);

  // }

  // Future<void> updateNote(NoteEntity note) async {
  //   emit(AddNoteLoading());
  //   final result = await noteUsecase.updateNote(note);

  // }
}
