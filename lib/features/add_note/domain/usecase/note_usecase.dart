import 'package:dartz/dartz.dart';

import '../entity/note_entity.dart';
import '../repositoy/note_repository.dart';

class NoteUsecase {
  final NoteRepository noteRepository;
  NoteUsecase(this.noteRepository);

  Future<Either<String, String>> addNote(NoteEntity note) async {
    return await noteRepository.addNote(note);
  }

  Future<Either<String, List<NoteEntity>>> getNotes() async {
    return await noteRepository.getNotes();
  }

  Future<Either<String, String>> deleteNote(int id) async {
    return await noteRepository.deleteNote(id);
  }

  Future<Either<String, String>> updateNote(NoteEntity note) async {
    return await noteRepository.updateNote(note);
  }
}
