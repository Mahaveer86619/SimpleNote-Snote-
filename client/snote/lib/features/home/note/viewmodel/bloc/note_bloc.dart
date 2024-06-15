import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/core/common/app_user/app_user_cubit.dart';
import 'package:snote/core/model/note_details.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;
  final AppUserCubit _appUserCubit;

  NoteBloc({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
    required AppUserCubit appUserCubit,
  })  : _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences,
        _appUserCubit = appUserCubit,
        super(NoteInitial()) {
    on<NoteEvent>((_, emit) => emit(NoteLoading()));
  }
}
