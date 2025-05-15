import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lu_cafe/core/common/ui/custom_button.dart';
import 'package:lu_cafe/core/utils/utils.dart';
import 'package:lu_cafe/features/admin/presentation/screens/admin_login_screen.dart';
import 'package:lu_cafe/features/auth/presentation/screens/register_screen.dart';
import 'package:lu_cafe/features/auth/presentation/widgets/custom_textfield.dart';

import '../../../../core/common/constants/constants.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      ref
          .read(authStateNotifierProvider.notifier)
          .login(context: context, email: email, password: password);
    } else {
      showDialogMesssageToUser(context,
          title: 'Error!!', message: 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: SingleChildScrollView(
          child: Stack(
            // alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Text(''),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        Constants.appLogo,
                        width: 180,
                      ),
                    ),
                    Gap(20),
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 5,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Gap(25),
                              Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(5),
                              Text(
                                'Login to your account',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Gap(40),
                              CustomTextfield(
                                controller: _emailController,
                                hint: 'Email',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Gap(10),
                              CustomTextfield(
                                controller: _passwordController,
                                hint: 'Password',
                                keyboardType: TextInputType.visiblePassword,
                                icon: Icons.lock,
                                obscureText: true,
                              ),
                              
                              Gap(20),
                              CustomButton(button: 'Login', onPressed: _login),
                            ],
                          )),
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?'),
                        Gap(5),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              // color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // are you an admin
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Are you an admin?'),
                        Gap(5),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminLoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              // color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
