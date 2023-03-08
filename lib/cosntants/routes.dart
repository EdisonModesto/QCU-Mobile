import 'package:go_router/go_router.dart';
import 'package:qcu/common/authentication/AuthView.dart';
import 'package:qcu/features/NavBar.dart';
import 'package:qcu/main.dart';

class AppRoute{
  var router = GoRouter(
    initialLocation: '/nav',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AppRoot(),
      ),

      GoRoute(
        path: '/nav',
        builder: (context, state) => const AppNavBar(),
      ),
      GoRoute(
        path: "/auth",
        builder: (context, state) => const AuthView(),
      )
    ],
  );
}