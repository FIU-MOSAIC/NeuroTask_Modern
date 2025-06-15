import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';

class RegisterForm extends StatefulWidget {

  const RegisterForm({super.key});
  
  @override
  State<StatefulWidget> createState() => _RegisterFormState();

}

class _RegisterFormState extends State<RegisterForm> {

  final _controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _controller.emailController,
            validator: (value) => value!.isEmpty ? "Email cannot be empty" : null,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller.passwordController,
            validator: (value) => value!.isEmpty ? "Password cannot be empty" : null,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _controller.submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50)
            ),
            child: const Text("Sign up")
          )
        ],
      ),
    );
  }

}

class RegisterController extends GetxController {

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void submit() {
    if (formKey.currentState!.validate()) {
      print("Registering ${emailController.text}");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

}