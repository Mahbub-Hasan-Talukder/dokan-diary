class NoteEntity {
  final int? id;
  final String? title;
  final String? description;
  final String? createdAt;

  NoteEntity({
    this.id,
    this.title,
    this.description,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'note_title': title,
      'note_content': description,
      'created_at': createdAt,
    };
  }
}
