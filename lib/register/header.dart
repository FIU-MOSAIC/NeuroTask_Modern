import 'package:flutter/material.dart';

/// RegisterPage's Header widget.
/// - A stateless widget for appearance
class RegisterHeader extends StatelessWidget {

  const RegisterHeader({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sign up",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 80),
        Row(
          children: [
            Expanded(child: Divider(thickness: 0.8, color: Colors.grey,)),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 8.0),
              child: Text(
                "Need an account?",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(child: Divider(thickness: 0.8, color: Colors.grey,)),
          ],
        )
      ],
    );
  }

}