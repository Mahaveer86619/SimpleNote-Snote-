import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/core/common/constants/app_constants.dart';
import 'package:snote/core/model/user_model.dart';
import 'package:snote/core/repository/app_repository.dart';
import 'package:snote/core/resources/data_state.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final AppRepository _appRepository;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  AppUserCubit({
    required AppRepository appRepository,
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  })  : _appRepository = appRepository,
        _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences,
        super(AppUserInitial());

  void updateUser(UserModel? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(user));
    }
  }

// This function is to be called wnen ever any screen is loaded to check token validity
  Future<void> loadUser() async {
    final userJson = _sharedPreferences.getString(USER_KEY);
    final tokenExpiryDateStr = _sharedPreferences.getString(TOKEN_EXPIRY);
    final refreshTokenExpiryDateStr =
        _sharedPreferences.getString(REFRESH_TOKEN_EXPIRY);

    if (userJson != null &&
        tokenExpiryDateStr != null &&
        refreshTokenExpiryDateStr != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap);
      final tokenKey = await _secureStorage.read(key: TOKEN_KEY);
      final refreshTokenKey = await _secureStorage.read(key: REFRESH_TOKEN_KEY);
      final tokenExpiryDate = _parseExpiryDate(tokenExpiryDateStr);
      final refreshTokenExpiryDate =
          _parseExpiryDate(refreshTokenExpiryDateStr);

      if (tokenKey != null &&
          refreshTokenKey != null &&
          tokenExpiryDate != null &&
          refreshTokenExpiryDate != null) {
        if (DateTime.now().isBefore(tokenExpiryDate)) {
          user.tokenKey = tokenKey;
          user.refreshTokenKey = refreshTokenKey;
          emit(AppUserLoggedIn(user));
        } else if (DateTime.now().isBefore(refreshTokenExpiryDate)) {
          await refreshRefreshTokenKey(refreshTokenKey);
          emit(AppUserLoggedIn(user));
        } else {
          logout();
        }
      } else {
        emit(AppUserInitial());
      }
    } else {
      emit(AppUserInitial());
    }
  }

  Future<void> refreshRefreshTokenKey(String refreshTokenKey) async {
    final response = await _appRepository.refreshAllTokens(refreshTokenKey);
    if (response is DataSuccess) {
      final tokenKey = response.data![TOKEN_KEY];
      final refreshTokenKey = response.data![REFRESH_TOKEN_KEY];

      await _secureStorage.write(key: TOKEN_KEY, value: tokenKey);
      await _secureStorage.write(
          key: REFRESH_TOKEN_KEY, value: refreshTokenKey);
      await saveTokenExpiryDates();
    } else {
      logout();
    }
  }

  Future<void> logout() async {
    await _sharedPreferences.remove(USER_KEY);
    await _secureStorage.delete(key: TOKEN_KEY);
    await _secureStorage.delete(key: REFRESH_TOKEN_KEY);
    await _sharedPreferences.remove(USER_KEY);
    await _sharedPreferences.remove(TOKEN_EXPIRY);
    await _sharedPreferences.remove(REFRESH_TOKEN_EXPIRY);
    emit(AppUserInitial());
  }

  Future<void> saveTokenExpiryDates() async {
    await _sharedPreferences.setString(
      TOKEN_EXPIRY,
      DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
    );
    await _sharedPreferences.setString(
      REFRESH_TOKEN_EXPIRY,
      DateTime.now().add(const Duration(days: 30)).toIso8601String(),
    );
  }

  DateTime? _parseExpiryDate(String? dateStr) {
    if (dateStr == null) return null;
    return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateStr);
  }
}
