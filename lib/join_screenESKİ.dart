import 'package:flutter/material.dart';
import 'routes.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),

                Image.asset(
                  "lib/assets/sabanci_logo.jpg",
                  height: 160,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Join SUboxd",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),

                const SizedBox(height: 30),

                TextField(
                  decoration: _input("Email address"),
                ),
                const SizedBox(height: 12),

                TextField(
                  decoration: _input("Username"),
                ),
                const SizedBox(height: 12),

                TextField(
                  obscureText: true,
                  decoration: _input("Password"),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bottomButton(
                      "SIGN IN",
                      const Color(0xFF2B3240),
                      () => Navigator.pushNamed(context, Routes.login),
                    ),
                    _bottomButton(
                      "RESET PASSWORD",
                      const Color(0xFF2B3240),
                      () {},
                    ),
                    _bottomButton(
                      "JOIN",
                      const Color(0xFF76C04E),
                      () => Navigator.pushNamed(context, Routes.friends),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration _input(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white24,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _bottomButton(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      height: 40,
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
