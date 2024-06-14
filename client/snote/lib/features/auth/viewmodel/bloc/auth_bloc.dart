import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/core/resources/data_state.dart';
import 'package:snote/features/auth/model/user_model.dart';
import 'package:snote/features/auth/repository/auth_remote_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteRepository authRemoteRepository;
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthBloc({
    required this.authRemoteRepository,
    required this.secureStorage,
    required this.sharedPreferences,
  }) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await authRemoteRepository.signUp(
      event.username,
      event.email,
      event.password,
    );
    if (res is DataSuccess) {
      await _saveUserDetails(res.data!);
      emit(AuthAuthenticated(res.data!));
    } else {
      emit(AuthError(res.error!, res.statusCode!));
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await authRemoteRepository.signIn(
      event.email,
      event.password,
    );
    if (res is DataSuccess) {
      await _saveUserDetails(res.data!);
      emit(AuthAuthenticated(res.data!));
    } else {
      emit(AuthError(res.error!, res.statusCode!));
    }
  }

  Future<void> _saveUserDetails(UserModel user) async {
    await secureStorage.write(key: 'tokenKey', value: user.tokenKey);
    await secureStorage.write(key: 'refreshTokenKey', value: user.refreshTokenKey);
    await sharedPreferences.setString('user', jsonEncode(user.toJson()));
  }
}
