import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_auth/persentation/bloc/authenticating_bloc.dart';
import 'package:module_core/theme/theme.dart';
import 'package:module_core/theme/util.dart';
import 'package:swalayam_ku/injector.dart';
import 'package:swalayam_ku/router/myrouter.dart';
import 'package:swalayam_ku/injector.dart' as injector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBIwjQUT0klnG3D_QLAwfVCAVPKuzw7coQ",
      appId: "1:93360381086:web:92a5aa9515d8d60f922f8f",
      messagingSenderId: "93360381086",
      projectId: "swalayanku-30436",
    ),
  );
  await injector.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<AuthenticatingBloc>()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthenticatingBloc>();
    TextTheme textTheme = createTextTheme(
      context,
      "Roboto Flex",
      "Roboto Flex",
    );
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      routerConfig: MyRouter(auth).myRouter(),
      theme: theme.light(),
    );
  }
}
