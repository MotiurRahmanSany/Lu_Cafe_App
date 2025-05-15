import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_cafe/config/app_router.dart';
import 'package:lu_cafe/config/app_theme.dart';
import 'package:lu_cafe/core/common/constants/constants.dart';
import 'package:lu_cafe/core/utils/user_model_enum.dart';
import 'package:lu_cafe/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lu_cafe/features/auth/presentation/screens/login_screen.dart';
import 'package:lu_cafe/features/admin/presentation/screens/admin_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(authStateNotifierProvider);
    final appRouter = ref.watch(appRouterProvider);

    if (appUser != null) {
      if (appUser.role == UserRole.admin) {
        return MaterialApp(
          title: Constants.appTitle,
          theme: appTheme,
          home: const AdminHomeScreen(),
        );
      } else {
        return MaterialApp.router(
          title: Constants.appTitle,
          theme: appTheme,
          routerConfig: appRouter,
        );
      }
    } else {
      return MaterialApp(
        title: Constants.appTitle,
        theme: appTheme,
        home: const LoginScreen(),
      );
    }
  }
}
