import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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

                // Sabancı logosu
                Image.asset(
                  "assets/logo.png",
                  height: 160,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Sign in to SUboxd",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                // Username
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    hintText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Password
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Alt 3 buton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bottomButton(
                      label: "JOIN",
                      color: const Color(0xFF2B3240),
                      onTap: () => Navigator.pushNamed(context, '/join'),
                    ),
                    _bottomButton(
                      label: "RESET PASSWORD",
                      color: const Color(0xFF2B3240),
                      onTap: () {},
                    ),
                    _bottomButton(
                      label: "GO",
                      color: const Color(0xFF76C04E),
                      // 🔹 GİRİŞ → HOME
                      onTap: () => Navigator.pushNamed(context, '/home'),
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

  Widget _bottomButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 40,
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}