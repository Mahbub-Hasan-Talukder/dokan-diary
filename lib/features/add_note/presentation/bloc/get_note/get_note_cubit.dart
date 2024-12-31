import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/note_usecase.dart';
import 'get_note_state.dart';

class GetNoteCubit extends Cubit<GetNoteState> {
  final NoteUsecase noteUsecase;
  GetNoteCubit(this.noteUsecase) : super(GetNoteInitial());

  Future<void> getNotes() async {
    emit(GetNoteLoading());
    final result = await noteUsecase.getNotes();
    result.fold((l) => emit(GetNoteFailure(l)), (r) => emit(GetNoteSuccess(r)));
  }
}
