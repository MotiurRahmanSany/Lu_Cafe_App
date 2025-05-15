import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_cafe/core/common/constants/route_const.dart';
import 'package:lu_cafe/core/common/ui/navigation_scaffold.dart';
import 'package:lu_cafe/features/cart/presentation/screens/cart_screen.dart';
import 'package:lu_cafe/features/order/presentation/checkout_screen.dart';
import 'package:lu_cafe/features/profile/presentation/screens/profile_screen.dart';
import 'package:lu_cafe/features/search/presentation/search_screen.dart';

import '../features/home/presentation/screens/food_details_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _firstShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'firstShell');
final _secondShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'secondShell');
final _thirdShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'thirdShell');

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      // search screen
      GoRoute(
        path: RouteLocPath.search,
        name: RouteLocName.search,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: SearchScreen(),
          );
        },
      ),

      // food details screen
      GoRoute(
        path: RouteLocPath.foodDetails,
        name: RouteLocName.foodDetails,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return MaterialPage(
            child: FoodDetailsScreen(foodId: id),
          );
        },
      ),

      // checkout screen
      GoRoute(
        path: RouteLocPath.checkout,
        name: RouteLocName.checkout,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: CheckoutScreen(),
          );
        },
      ),
      // delivery screen
      GoRoute(
        path: RouteLocPath.delivery,
        name: RouteLocName.delivery,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: CheckoutScreen(),
          );
        },
      ),

      StatefulShellRoute.indexedStack(
        // parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, child) {
          return NavigationScaffold(navigationShell: child);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _firstShellNavigatorKey,
            routes: [
              GoRoute(
                path: RouteLocPath.home,
                name: RouteLocName.home,
                pageBuilder: (context, state) => MaterialPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _secondShellNavigatorKey,
            routes: [
              GoRoute(
                path: RouteLocPath.cart,
                name: RouteLocName.cart,
                pageBuilder: (context, state) => MaterialPage(
                  child: CartScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _thirdShellNavigatorKey,
            routes: [
              GoRoute(
                path: RouteLocPath.profile,
                name: RouteLocName.profile,
                pageBuilder: (context, state) => MaterialPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      )
    ],
  );
});
