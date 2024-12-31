abstract class RemoteNoteDataSource {
  Future<void> deleteNote(int id);
  Future<void> updateNote(int id, Map<String, dynamic> note);
}
