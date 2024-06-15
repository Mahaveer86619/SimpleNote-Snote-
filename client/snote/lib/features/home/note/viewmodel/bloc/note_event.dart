part of 'note_bloc.dart';

sealed class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotes extends NoteEvent {}

class FetchNote extends NoteEvent {
  final String noteId;

  const FetchNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class RefreshNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final NoteDetails note;

  const AddNote(this.note);

  @override
  List<Object?> get props => [note];
}

class EditNote extends NoteEvent {
  final NoteDetails note;

  const EditNote(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NoteEvent {
  final String noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

final class LogOut extends NoteEvent {}