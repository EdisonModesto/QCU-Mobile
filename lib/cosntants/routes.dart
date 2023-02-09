import 'package:go_router/go_router.dart';
import 'package:qcu/features/NavBar.dart';
import 'package:qcu/features/authentication/LoginView.dart';
import 'package:qcu/features/authentication/SignupView.dart';
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
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupView(),
      ),
      GoRoute(
        path: '/nav',
        builder: (context, state) => const AppNavBar(),
      ),
    ],
  );
}