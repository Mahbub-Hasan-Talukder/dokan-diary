import '../../domain/entity/note_entity.dart';

class NoteModel {
  final int? id;
  final String? title;
  final String? description;
  final String? createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['note_id'],
      title: json['note_title'],
      description: json['note_content'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note_title': title,
      'note_content': description,
      'created_at': createdAt,
    };
  }

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
    );
  }
}
