import 'package:diary/features/add_note/domain/usecase/note_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/note_entity.dart';
import 'update_note_state.dart';

class UpdateNoteCubit extends Cubit<UpdateNoteState> {
  final NoteUsecase noteUsecase;
  UpdateNoteCubit(this.noteUsecase) : super(UpdateNoteInitial());

  Future<void> updateNote(NoteEntity note) async {
    emit(UpdateNoteLoading());
    final result = await noteUsecase.updateNote(note);
    result.fold(
        (l) => emit(UpdateNoteFailure(l)), (r) => emit(UpdateNoteSuccess(r)));
  }
}
