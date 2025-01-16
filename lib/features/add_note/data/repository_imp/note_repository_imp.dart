import 'package:dartz/dartz.dart';

import '../../domain/entity/note_entity.dart';
import '../../domain/repositoy/note_repository.dart';
import '../data_source/local_data_source/note_local_data_source.dart';
import '../data_source/remote_data_source/note_remote_data_source.dart';
import '../model/note_model.dart';

class NoteRepositoryImp extends NoteRepository {
  final NoteLocalDataSource noteLocalDataSource;
  final RemoteNoteDataSource noteRemoteDataSource;
  NoteRepositoryImp(this.noteLocalDataSource, this.noteRemoteDataSource);

  @override
  Future<Either<String, String>> addNote(NoteEntity note) async {
    try {
      await noteLocalDataSource.addNote(note.toJson());
      return right('Note added successfully');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteNote(int id) async {
    try {
      await noteRemoteDataSource.deleteNote(id);
      await noteLocalDataSource.deleteNote(id);
      return right('Note deleted successfully');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<NoteEntity>>> getNotes() async {
    try {
      final notes = await noteLocalDataSource.getNotes();
      return right(
          notes.map((note) => NoteModel.fromJson(note).toEntity()).toList());
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> updateNote(NoteEntity note) async {
    try {
      await noteRemoteDataSource.updateNote(note.id ?? 0, note.toJson());
      await noteLocalDataSource.updateNote(note.id ?? 0, note.toJson());
      return right('Note updated successfully');
    } catch (e) {
      return left(e.toString());
    }
  }
}
