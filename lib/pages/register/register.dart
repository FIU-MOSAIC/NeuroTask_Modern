import 'package:flutter/material.dart';
import 'package:neurotask_ng/pages/register/form.dart';
import 'package:neurotask_ng/pages/register/header.dart';

/// An orchestrator widget that renders the /register page's layout
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 82.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 80),

                const RegisterHeader(),

                const SizedBox(height: 60),

                RegisterForm(),

                const SizedBox(height: 160),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
