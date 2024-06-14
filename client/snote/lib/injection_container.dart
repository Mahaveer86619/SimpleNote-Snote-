import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/features/auth/repository/auth_remote_repository.dart';
import 'package:snote/features/auth/viewmodel/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> registerServices() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();
  sl.registerSingleton<FlutterSecureStorage>(secureStorage);

  // Register AuthRemoteRepository
  sl.registerLazySingleton<AuthRemoteRepository>(() => AuthRemoteRepository());

  // Register AuthBloc
  sl.registerFactory(() => AuthBloc(
        authRemoteRepository: sl<AuthRemoteRepository>(),
        secureStorage: sl<FlutterSecureStorage>(),
        sharedPreferences: sl<SharedPreferences>(),
      ));
}