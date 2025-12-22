import 'package:flutter/material.dart';

class SuboxdFooterDark extends StatelessWidget {
  const SuboxdFooterDark({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/su_boxd_logo2.png',
              height: 16,
            ),
            const SizedBox(width: 6),
            const Text(
              'SUboxd',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
