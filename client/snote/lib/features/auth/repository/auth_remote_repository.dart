import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:snote/core/resources/data_state.dart';
import 'package:snote/features/auth/model/user_model.dart';

class AuthRemoteRepository {
  Future<DataState<UserModel>> signUp(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/auth/signup',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'username': username,
            'email': email,
            'password': password,
          },
        ),
      );
      if (response.statusCode != 201) {
        return DataFailure(response.body, response.statusCode);
      }
      return DataSuccess(UserModel.fromJson(jsonDecode(response.body)));
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<UserModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/auth/signin',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      if (response.statusCode != 200) {
        return DataFailure(response.body, response.statusCode);
      }
      return DataSuccess(UserModel.fromJson(jsonDecode(response.body)));
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }
}
