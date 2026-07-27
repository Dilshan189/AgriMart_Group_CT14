import 'package:flutter/material.dart';
import '../../../../../core/router/app_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Splash background image from assets
          Positioned.fill(
            child: Image.asset('assets/images/Splash.png', fit: BoxFit.cover),
          ),

          // Main content (Buttons)
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // ── Logo Image ──
                Center(
                  child: Image.asset(
                    'assets/images/Group 462.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 16),

                // ── App Name ──
                const Text(
                  'AgriMart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.2,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Tagline ──
                const Text(
                  'Connecting Farmers & Buyers\nthrough Agricultural Officers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB5CE9F),
                    fontSize: 14,
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                ),

                const SizedBox(height: 35),

                // ── Buttons ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.login);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF5A8441,
                            ), // Lighter green fill
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.register);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2E5E16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
