import 'package:go_router/go_router.dart';
import 'package:qcu/common/authentication/AuthView.dart';
import 'package:qcu/common/chat/ConvoListView.dart';
import 'package:qcu/common/itemDetails/SellerVisitView.dart';
import 'package:qcu/common/search/SearchView.dart';
import 'package:qcu/common/settings/PrivacyView.dart';
import 'package:qcu/features/NavBar.dart';
import 'package:qcu/main.dart';

import '../common/chat/ChatView.dart';

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
      ),
      GoRoute(
        path: "/convoList",
        builder: (context, state) => const ConvoListView(),
      ),
      GoRoute(
        path: "/chat/:seller/:buyer",
        name: "chat",
        builder: (context, state) => ChatView(seller: state.params["seller"], buyer: state.params["buyer"],),
      ),
      GoRoute(
        path: "/search",
        builder: (context, state) => const SearchView(),
      ),
      GoRoute(
        path: "/sellerStore/:sellerID",
        name: "sellerStore",
        builder: (context, state) => SellerVisitView(sellerID: state.params["sellerID"],),
      ),
      GoRoute(
        path: "/privacy",
        builder: (context, state) => const PrivacyView(),
      )
    ],
  );
}