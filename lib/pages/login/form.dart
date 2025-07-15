import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/services/auth_service.dart';

/// LoginPage's Form widget.
/// - Holds all the stateful data the user provides when logging in.
class LoginForm extends StatefulWidget {

  const LoginForm({super.key});
  
  @override
  State<StatefulWidget> createState() => _LoginFormState();

}

class _LoginFormState extends State<LoginForm> {

  final _controller = Get.put(LoginFormController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _controller.emailController,
            validator: (value) => value!.isEmpty ? 'Email cannot be empty' : null,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller.passwordController,
            validator: (value) => value!.isEmpty ? 'Password cannot be empty' : null,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder()
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: _controller.submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50)
            ),
            child: const Text("Login")
          ),
        ],
      ),
    );
  }

}

class LoginFormController extends GetxController {

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthService();

  void submit() async {

    if (!formKey.currentState!.validate()) return;

    try {

      final user = await _authService.loginWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
      );

      if (user != null) {
        Get.offAllNamed('/home');
      }

    } catch (e) {
      Get.snackbar(
        'Login Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

}