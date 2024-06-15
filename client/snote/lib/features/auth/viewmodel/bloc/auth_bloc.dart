import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/core/common/app_user/app_user_cubit.dart';
import 'package:snote/core/common/constants/app_constants.dart';
import 'package:snote/core/resources/data_state.dart';
import 'package:snote/core/model/user_model.dart';
import 'package:snote/features/auth/repository/auth_remote_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteRepository _authRemoteRepository;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required AuthRemoteRepository authRemoteRepository,
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
    required AppUserCubit appUserCubit,
  }) :_authRemoteRepository = authRemoteRepository,
      _secureStorage = secureStorage,
      _sharedPreferences = sharedPreferences,
      _appUserCubit = appUserCubit,
      super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _authRemoteRepository.signUp(
      event.username,
      event.email,
      event.password,
    );
    if (res is DataSuccess) {
      await _saveUserDetails(res.data!);
      await _appUserCubit.saveTokenExpiryDates();
      _appUserCubit.updateUser(res.data!);
      emit(AuthAuthenticated(res.data!));
    } else {
      emit(AuthError(res.error!, res.statusCode!));
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _authRemoteRepository.signIn(
      event.email,
      event.password,
    );
    if (res is DataSuccess) {
      await _saveUserDetails(res.data!);
      await _appUserCubit.saveTokenExpiryDates();
      _appUserCubit.updateUser(res.data!);
      emit(AuthAuthenticated(res.data!));
    } else {
      emit(AuthError(res.error!, res.statusCode!));
    }
  }

  Future<void> _saveUserDetails(UserModel user) async {
    await _secureStorage.write(key: TOKEN_KEY, value: user.tokenKey);
    await _secureStorage.write(key: REFRESH_TOKEN_KEY, value: user.refreshTokenKey);
    await _sharedPreferences.setString(USER_KEY, jsonEncode(user.toJson()));
  }

}
