import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/note_usecase.dart';
import 'delete_note_state.dart';

class DeleteNoteCubit extends Cubit<DeleteNoteState> {
  final NoteUsecase noteUsecase;
  DeleteNoteCubit(this.noteUsecase) : super(DeleteNoteInitial());

  Future<void> deleteNote(int id) async {
    emit(DeleteNoteLoading());
    final result = await noteUsecase.deleteNote(id);
    result.fold(
        (l) => emit(DeleteNoteFailure(l)), (r) => emit(DeleteNoteSuccess(r)));
  }
}
