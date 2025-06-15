import 'package:flutter/material.dart';
import 'package:neurotask_ng/register/form.dart';
import 'package:neurotask_ng/register/header.dart';

class RegisterPage extends StatelessWidget {

  const RegisterPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 82.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              const SizedBox(height: 80),

              const RegisterHeader(),

              const SizedBox(height: 60),

              RegisterForm(),

            ],
          ),
        ),
      ),
    );
  }

}