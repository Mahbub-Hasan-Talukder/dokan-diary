import 'package:dartz/dartz.dart';

import '../entity/note_entity.dart';

abstract class NoteRepository {
  Future<Either<String, String>> addNote(NoteEntity note);
  Future<Either<String, List<NoteEntity>>> getNotes();
  Future<Either<String, String>> deleteNote(int id);
  Future<Either<String, String>> updateNote(NoteEntity note);
}
