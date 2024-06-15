class NoteDetails {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? coverImagePath;
  final String creatorEmail;
  final int noteColorIndex;

  NoteDetails({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    this.coverImagePath,
    required this.creatorEmail,
    required this.noteColorIndex,
  });

  NoteDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']),
        category = json['category'],
        coverImagePath = json['coverImagePath'],
        creatorEmail = json['creatorEmail'],
        noteColorIndex = int.parse(json['noteColorIndex']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category,
      'coverImagePath': coverImagePath,
      'creatorEmail': creatorEmail,
      'noteColorIndex': noteColorIndex.toString(),
    };
  }

  NoteDetails copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    String? coverImagePath,
    String? creatorEmail,
    int? noteColorIndex,
  }) {
    return NoteDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      creatorEmail: creatorEmail ?? this.creatorEmail,
      noteColorIndex: noteColorIndex ?? this.noteColorIndex,
    );
  }

  bool hasCoverImage() {
    return coverImagePath != null;
  }
}
