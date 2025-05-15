import 'package:flutter/material.dart';

class TermsNConditionScreen extends StatelessWidget {
  const TermsNConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Introduction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to the LU Cafeteria app. By using this app, you agree to comply with and be bound by the following terms and conditions. If you do not agree to these terms, please do not use the app. These terms apply to all users of the LU Cafeteria app, including both visitors and registered users.\n\nApp Name: LU Cafeteria\nUniversity Name: Leading University (LU)\nService Offered: Online food ordering for users within the university campus.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '1. Eligibility',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'To use the LU Cafeteria app, you must be a current student, faculty, or staff member of Leading University (LU) and must have access to the internet. By using this app, you confirm that you meet the eligibility criteria and are at least 18 years old or have consent from a legal guardian.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2. User Registration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'When you register on the LU Cafeteria app, you must provide accurate and complete information. You agree to update your registration details if they change. You are responsible for maintaining the confidentiality of your account details, including your username and password.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3. Ordering Process',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Users can place food orders through the app, which are fulfilled by the LU Cafeteria. The App allows users to browse the menu, select items, and place orders. All orders placed through the app are subject to availability.\n\nOrder Confirmation: You will receive an order confirmation after placing your order, including estimated delivery/pickup time.\nPayment Method: The only available payment method is Cash on Delivery (COD). No online payments are accepted.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '4. Delivery and Pickup',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Orders placed via the LU Cafeteria app will be processed and delivered within the university premises as per the delivery/pickup time provided in the order confirmation. The LU Cafeteria is not responsible for delays caused by factors outside of our control.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '5. Cancellation and Modifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Once your order is confirmed, cancellation or modifications are not allowed unless there are valid reasons (e.g., product availability or a technical issue). In case of issues, please contact the LU Cafeteria support team at the earliest.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '6. Prices and Payment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Prices: All prices listed on the app are in the university\'s local currency.\nPayment: All payments are made via cash upon delivery. Users are required to provide the exact amount or be ready to pay the agreed-upon amount in full at the time of delivery or pickup.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '7. User Responsibilities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Accurate Information: You agree to provide accurate and truthful information when using the app.\nNo Misuse: You agree not to misuse the app for any unlawful or prohibited purpose.\nProper Use: You must use the app in accordance with the university\'s rules and regulations, and any violation may result in suspension of your access to the app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '8. Intellectual Property',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'The content, features, and functionality of the LU Cafeteria app are owned by Leading University and protected by intellectual property laws. Users are prohibited from reproducing, distributing, or using any part of the app’s content without prior written consent from the university.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '9. Privacy and Data Protection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Your privacy is important to us. We collect personal information when you register or use the app to ensure smooth order processing and delivery. For more details on how we handle your personal information, please refer to our Privacy Policy (if available).',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '10. Limitation of Liability',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'The LU Cafeteria app and its services are provided on an "as-is" and "as available" basis. While we strive to provide the best experience, we do not guarantee the app’s availability or performance at all times. Leading University is not liable for any direct, indirect, incidental, special, or consequential damages that result from the use or inability to use the app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '11. Termination of Use',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Leading University reserves the right to suspend or terminate your access to the LU Cafeteria app at any time, without prior notice, if you violate these terms and conditions or if the app’s operation is interrupted or discontinued for any reason.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '12. Governing Law',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'These terms and conditions are governed by the laws of the country and jurisdiction in which Leading University operates. Any disputes will be handled within the appropriate legal venue.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '13. Changes to Terms and Conditions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Leading University reserves the right to modify, update, or change these terms and conditions at any time. Users will be notified of any significant changes, and the updated version of these terms will be posted on the app. By continuing to use the app after the changes, you agree to the new terms.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '14. Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'If you have any questions or concerns about these terms, please contact us at:\n\nEmail: [Insert University Support Email]\nPhone: [Insert University Support Number]\nAddress: [Insert University Address]',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
