import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:lu_cafe/core/common/ui/custom_icon_button.dart';
import '../../../../core/common/constants/constants.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  bool showDeliveryAnimation = false;

  @override
  void initState() {
    super.initState();
    _playSequentialAnimations();
  }

  void _playSequentialAnimations() async {
    // Wait time for Flare and Cart animations to play twice
    await Future.delayed(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        showDeliveryAnimation = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your delicious food is being prepared! 🍽️',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
              ),
              const SizedBox(height: 20),

              // Conditional Animation Display
              if (!showDeliveryAnimation) ...[
                Lottie.asset(Constants.flareAnimation,
                    repeat: false, width: 200),
                const SizedBox(height: 10),
                Lottie.asset(Constants.cartAnimation,
                    repeat: false, width: 150),
              ] else ...[
                Lottie.asset(Constants.deliveryAnimation,
                    repeat: true, width: 180),
                const SizedBox(height: 20),
                Text(
                  'Thanks for ordering! Your food is on the way 🚴💨',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                ),
              ],

              const SizedBox(height: 30),
              CustomIconButton(
                onPressed: () {
                  print('going to home screen');
                  context.pop();
                  context.pop();
                },
                label: 'Go to Cart!',
                icon: Icons.home,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
