import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:neurotask_ng/login/header.dart';
import 'package:neurotask_ng/login/form.dart';

/// An orchestrator widget that renders the /login page's layout
class LoginPage extends StatelessWidget {

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 82.0),
        child: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              SizedBox(height: 80),

              LoginHeader(),

              const SizedBox(height: 60),

              LoginForm(),

              const SizedBox(height: 50),

              TextButton(
                onPressed: () => Get.toNamed('/register'),
                child: Text("Create an account")
              ),

            ],
          )
        ),
      ),
    );
  }

}