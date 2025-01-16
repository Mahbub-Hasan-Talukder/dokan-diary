abstract class NoteLocalDataSource {
  Future<void> addNote(Map<String, dynamic> note);
  Future<List<Map<String, dynamic>>> getNotes();
  Future<void> deleteNote(int id);
  Future<void> updateNote(int id, Map<String, dynamic> note);
}
