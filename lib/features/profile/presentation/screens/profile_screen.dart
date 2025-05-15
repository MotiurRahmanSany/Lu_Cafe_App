import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lu_cafe/core/utils/enums.dart';
import 'package:lu_cafe/core/utils/utils.dart';
import 'package:lu_cafe/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lu_cafe/features/profile/presentation/screens/terms_n_condition_screen.dart';

import '../../../../core/common/constants/constants.dart';
import '../widgets/profile_list_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _logOut() {
    print('logout pressed');
    ref.read(authStateNotifierProvider.notifier).logout(context);
  }

  void _showTNC() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsNConditionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(currentUserProvider);
    return Scaffold(
      body: appUser.when(
        data: (user) => SizedBox(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 45, left: 20, right: 20),
                    height: MediaQuery.of(context).size.height / 4.3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 105),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 6.5,
                    ),
                    child: Center(
                      child: Material(
                        borderRadius: BorderRadius.circular(60),
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            Constants.avatar,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LUian',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 50,
                    child: IconButton(
                      onPressed: () =>
                          showLogoutConfirmDialog(context, _logOut),
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      iconSize: 26,
                    ),
                  ),
                ],
              ),
              ProfileListTile(
                icon: Icons.person,
                title: 'Name',
                description: getNameFromEmail(user!.user.email).firstCap(),
                onPressed: () {},
              ),

              // Pro
              ProfileListTile(
                icon: Icons.email_outlined,
                title: 'Email',
                description: user.user.email,
                onPressed: () {},
              ),
              ProfileListTile(
                icon: Icons.toc,
                title: 'Terms & Condition',
                description: 'Read our terms and conditions',
                onPressed: _showTNC,
              ),

              // ProfileListTile(
              //   icon: Icons.logout,
              //   title: 'Logout',
              //   onPressed: () => showLogoutConfirmDialog(context, _logOut),
              //   description: 'Logout from your account',
              // ),
            ],
          ),
        ),
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Loading User Data...'),
              Gap(10),
              CircularProgressIndicator(),
            ],
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
