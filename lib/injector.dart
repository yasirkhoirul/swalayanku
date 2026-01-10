import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:module_auth/data/auth_repository_impl.dart';
import 'package:module_auth/data/datasource/auth_remote_datasource.dart';
import 'package:module_auth/domain/repository/auth_repository.dart';
import 'package:module_auth/domain/usecase/check_login.dart';
import 'package:module_auth/domain/usecase/get_login.dart';
import 'package:module_auth/domain/usecase/get_logout.dart';
import 'package:module_auth/persentation/bloc/authenticating_bloc.dart';

final locator = GetIt.instance;

Future<void> init()async{
  //datasource
  locator.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl(locator()),);

  //repository
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(locator()),);

  //usecase
  locator.registerLazySingleton(() => GetLogin(locator()),);
  locator.registerLazySingleton(() => GetLogout(locator()),);
  locator.registerLazySingleton(() => CheckLogin(locator()),);

  //bloc
  locator.registerLazySingleton<AuthenticatingBloc>(() => AuthenticatingBloc(locator(),locator(),locator()),);


  //Firebase
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
}