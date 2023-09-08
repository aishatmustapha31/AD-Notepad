class NoteModel {
  String noteId;
  String noteTitle;
  String noteImage;
  String noteDescription;

  NoteModel(
      {required this.noteId,
      required this.noteTitle,
      required this.noteImage,
      required this.noteDescription});

  Map<String, dynamic> toJson() {
    return {
      'note_id': noteId,
      'note_title': noteTitle,
      'note_image': noteImage,
      'note_description': noteDescription
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
        noteId: json['note_id'],
        noteTitle: json['note_title'],
        noteImage: json['note_image'] ?? '',
        noteDescription: json['note_description']);
  }
}
