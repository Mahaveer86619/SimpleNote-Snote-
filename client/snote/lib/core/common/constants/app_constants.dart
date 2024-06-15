import 'package:flutter/material.dart';

const String TOKEN_KEY = 'tokenKey';
const String REFRESH_TOKEN_KEY = 'refreshTokenKey';
const String USER_KEY = 'user';
const String TOKEN_EXPIRY = 'appTokenExpiry';
const String REFRESH_TOKEN_EXPIRY = 'refreshTokenExpiry';

enum Category {
  general,
  work,
  study,
  important,
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.general:
        return 'General';
      case Category.work:
        return 'Work';
      case Category.study:
        return 'Study';
      case Category.important:
        return 'Important';
    }
  }
  IconData get icon {
    switch (this) {
      case Category.general:
        return Icons.book;
      case Category.work:
        return Icons.work;
      case Category.study:
        return Icons.school;
      case Category.important:
        return Icons.star;
    }
  }
}

List<Color> noteColors = [
  const Color(0xFFF4734A),
  const Color(0xFFFBBC05),
  const Color(0xFFE46262),
];