import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lu_cafe/core/common/ui/custom_button.dart';
import 'package:lu_cafe/features/auth/presentation/screens/login_screen.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../../core/utils/utils.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _register() {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        ref
            .read(authStateNotifierProvider.notifier)
            .register(context: context, email: email, password: password);
      } else {
        showDialogMesssageToUser(
          context,
          title: 'Password did not match!',
          message: 'Please make sure your password match',
        );
      }
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
                          height: MediaQuery.of(context).size.height / 1.65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Gap(25),
                              Text(
                                'Create an Account',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(5),
                              Text(
                                'Register to get started',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Gap(40),
                              CustomTextfield(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                hint: 'Email',
                                icon: Icons.email,
                              ),
                              Gap(10),
                              CustomTextfield(
                                keyboardType: TextInputType.visiblePassword,
                                controller: _passwordController,
                                hint: 'Password',
                                icon: Icons.lock,
                                obscureText: true,
                              ),
                              Gap(10),
                              CustomTextfield(
                                keyboardType: TextInputType.visiblePassword,
                                controller: _confirmPasswordController,
                                hint: 'Confirm Password',
                                icon: Icons.lock,
                                obscureText: true,
                              ),
                              Gap(20),
                              CustomButton(
                                  button: 'Register', onPressed: _register),
                            ],
                          )),
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        Gap(5),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(),
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
