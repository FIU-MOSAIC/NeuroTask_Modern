import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {

  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sign in",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 80),
        Row(
          children: [
            Expanded(child: Divider(thickness: 0.8, color: Colors.grey)),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 8.0),
              child: Text(
                "Log in to continue",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(child: Divider(thickness: 0.8, color: Colors.grey)),
          ]
        )
      ],
    );
  }

}