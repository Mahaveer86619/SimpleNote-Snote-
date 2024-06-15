import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:snote/core/resources/data_state.dart';

class AppRepository {
  Future<DataState<Map<String, dynamic>>> refreshAllTokens(
    String refreshTokenKey,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/auth/refresh',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'refreshToken': refreshTokenKey,
          },
        ),
      );
      if (response.statusCode != 201) {
        return DataFailure(response.body, response.statusCode);
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return DataSuccess(data);
      }
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }
}
