import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snote/core/common/app_user/app_user_cubit.dart';
import 'package:snote/core/themes/theme.dart';
import 'package:snote/features/auth/view/pages/signin_page.dart';
import 'package:snote/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:snote/features/home/main_wrapper.dart';
import 'package:snote/injection_container.dart' as di;

void main() async {
  await setup();
  runApp(const MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.registerServices();
  await dotenv.load(fileName: '.env');

  final appUserCubit = di.sl<AppUserCubit>();
  await appUserCubit.loadUser();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppUserCubit>(
          create: (context) => di.sl<AppUserCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Snote',
        theme: lightMode,
        darkTheme: darkMode,
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        if (state is AppUserLoggedIn) {
          return const MainWrapper();
        } else {
          if (state is AppUserInitial && state.message != null) {
            final message = state.message;
            return SignInPage(message: message);
          }
          return SignInPage();
        }
      },
    );
  }
}
