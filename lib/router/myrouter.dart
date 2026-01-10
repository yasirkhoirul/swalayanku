import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:module_admin/module_admin.dart';
import 'package:module_auth/persentation/bloc/authenticating_bloc.dart';
import 'package:module_auth/persentation/listener/auth_listener.dart';
import 'package:module_auth/persentation/pages/login_page.dart';
import 'package:module_core/module_core.dart';

class MyRouter {
  final AuthenticatingBloc authBloc;
  const MyRouter(this.authBloc);

  GoRouter myRouter() {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: AuthListener(authBloc),
      routes: [
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainScaffold(statefulNavigationShell: navigationShell, onLogout: () { context.read<AuthenticatingBloc>().add(AuthOnLogout()); },),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: '/homeAdmin', builder: (context, state) => ListBarangPage(),)
            ])
          ],
        ),
      ],
      redirect: (context, state) {
        final bool isLogin = authBloc.state is AuthenticatingSucces;

        final securePath = ['/homeAdmin'];

        if (!isLogin && securePath.contains(state.fullPath)) {
          return '/login';
        }
        if (isLogin && !securePath.contains(state.fullPath)) {
          return '/homeAdmin';
        }


      },
    );
  }
}
