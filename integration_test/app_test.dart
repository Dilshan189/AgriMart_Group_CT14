import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:agri_mart/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify login screen handles dummy credentials', (tester) async {
      app.main();
      
      // Wait for the app to settle and splash screen to dismiss
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check if we are on the login screen by finding the Email text field
      final emailFields = find.byType(TextField);
      
      if (emailFields.evaluate().isEmpty) {
        print('Could not find TextField. Are you already logged in on the emulator?');
        return;
      }
      
      // We assume the first TextField is the Email/Phone field
      final emailField = emailFields.first;
      
      // Enter dummy email
      await tester.enterText(emailField, 'test@example.com');
      
      // We assume the second TextField is the Password field
      final passwordField = emailFields.at(1);
      
      // Enter dummy password
      await tester.enterText(passwordField, 'wrongpassword123');
      
      // Select a Role (e.g., 'Farmer')
      // Let's find the text 'Farmer' which is inside a GestureDetector or container
      final farmerRoleCard = find.text('Farmer');
      if (farmerRoleCard.evaluate().isNotEmpty) {
        await tester.tap(farmerRoleCard.first);
        await tester.pumpAndSettle();
      }
      
      // Find Login button
      final loginButton = find.text('Login');
      expect(loginButton, findsOneWidget);
      
      // Tap login
      await tester.tap(loginButton);
      
      // Wait for the authentication process to fail and show a snackbar
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // The app should show a SnackBar because credentials are wrong
      expect(find.byType(SnackBar), findsWidgets);
    });
  });
}
