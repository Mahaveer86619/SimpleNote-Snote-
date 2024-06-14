import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snote/core/themes/theme.dart';
import 'package:snote/features/auth/view/pages/signin_page.dart';
import 'package:snote/injection_container.dart' as di;

void main() async {
  await setup();
  runApp(const MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.registerServices();
  await dotenv.load(fileName: '.env');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snote',
      theme: lightMode,
      darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
      home: const SignInPage(),
    );
  }
}
