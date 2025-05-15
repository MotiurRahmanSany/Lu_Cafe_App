import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lu_cafe/features/auth/presentation/controllers/auth_controller.dart';

import '../../../../core/common/ui/custom_button.dart';
import '../../../../core/utils/utils.dart';
import '../../../auth/presentation/widgets/custom_textfield.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _adminLogin(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      showMessageToUser(
        context,
        message: 'Please fill all the fields correctly!',
      );

      return;
    }
    ref.read(authStateNotifierProvider.notifier).login(
          email: email,
          password: password,
          context: context,
          isAdminLogin: true,
        );
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.2),
              padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(
                      MediaQuery.of(context).size.width, 250.0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 60,
              ),
              child: Column(
                children: [
                  Text(
                    'Admin Login',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Gap(30),
                  Material(
                    elevation: 30,
                    type: MaterialType.canvas,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          spacing: 15,
                          children: [
                            Gap(20),
                            CustomTextfield(
                              controller: _emailController,
                              hint: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              icon: Icons.email,
                            ),
                            CustomTextfield(
                              controller: _passwordController,
                              hint: 'Password',
                              keyboardType: TextInputType.visiblePassword,
                              icon: Icons.lock,
                              obscureText: true,
                            ),
                            Gap(10),
                            CustomButton(
                              button: 'Login',
                              onPressed: () => _adminLogin(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
