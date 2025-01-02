import 'package:cloud_firestore/cloud_firestore.dart';

import 'note_remote_data_source.dart';

class RemoteNoteDataSourceImp implements RemoteNoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> addNote(Map<String, dynamic> note) async {
  //   await _firestore.collection('Notes').add(note);
  // }

  // Future<List<Map<String, dynamic>>> getNotes() async {
  //   final snapshot = await _firestore.collection('Notes').get();
  //   return snapshot.docs.map((doc) => doc.data()).toList();
  // }

  @override
  Future<void> deleteNote(int id) async {
    try {
      final snapshot =
          await _firestore.collection('Notes').doc(id.toString()).get();
      if (snapshot.exists) {
        await _firestore
            .collection('Notes')
            .doc(id.toString().replaceAll('/', '-'))
            .delete();
      } else {
        return;
      }
    } catch (e) {
      throw Exception('Failed to delete note');
    }
  }

  @override
  Future<void> updateNote(int id, Map<String, dynamic> note) async {
    try {
      final docSnapshot =
          await _firestore.collection('Notes').doc(id.toString()).get();
      if (docSnapshot.exists) {
        await _firestore
            .collection('Notes')
            .doc(id.toString().replaceAll('/', '-'))
            .update(note);
      } else {
        return;
      }
    } catch (e) {
      throw Exception('Failed to update note');
    }
  }
}
