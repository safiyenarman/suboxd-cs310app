import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1C2128);
    const lineColor = Color(0xFF97989B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 225),

            Center(
              child: SizedBox(
                width: 200,
                height: 90,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'SUboxd',
              style: TextStyle(
                fontSize: 68,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 32),

            Column(
              children: [
                _SplashButton(
                  label: 'Sign in',
                  hasTopBorder: true,
                  lineColor: lineColor,
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                _SplashButton(
                  label: 'Create account',
                  hasTopBorder: false,
                  lineColor: lineColor,
                  onTap: () {
                    Navigator.pushNamed(context, '/join');
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFF27333E),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: const [
              Icon(
                Icons.person,
                color: Colors.lightBlueAccent,
                size: 26,
              ),
              Positioned(
                right: -2,
                bottom: 8,
                child: Icon(
                  Icons.lock,
                  color: Colors.lightBlueAccent,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashButton extends StatelessWidget {
  final String label;
  final bool hasTopBorder;
  final Color lineColor;
  final VoidCallback? onTap;

  const _SplashButton({
    required this.label,
    required this.hasTopBorder,
    required this.lineColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          border: Border(
            top: hasTopBorder
                ? BorderSide(color: lineColor, width: 0.4)
                : BorderSide.none,
            bottom: BorderSide(color: lineColor, width: 0.4),
          ),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: lineColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}