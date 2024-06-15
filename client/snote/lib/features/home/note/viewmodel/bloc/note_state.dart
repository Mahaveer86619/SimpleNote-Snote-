part of 'note_bloc.dart';

sealed class NoteState extends Equatable {
  const NoteState();
  
  @override
  List<Object?> get props => [];
}

final class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<NoteDetails> notes;

  const NoteLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class NoteError extends NoteState {
  final String message;

  const NoteError(this.message);

  @override
  List<Object?> get props => [message];
}

class NoteAdded extends NoteState {}

class NoteEdited extends NoteState {}

class NoteDeleted extends NoteState {}