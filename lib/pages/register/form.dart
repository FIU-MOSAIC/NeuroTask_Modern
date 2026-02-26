import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart'; // AuthService import

/// RegisterPage's Form widget.
/// - Holds all the stateful data the user provides when signing up.
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
            validator: (value) =>
                value!.isEmpty ? "Email cannot be empty" : null,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller.passwordController,
            validator: (value) =>
                value!.isEmpty ? "Password cannot be empty" : null,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller.firstNameController,
            validator: (value) =>
                value!.isEmpty ? "First name must be provided" : null,
            decoration: const InputDecoration(
              labelText: 'First name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller.lastNameController,
            validator: (value) =>
                value!.isEmpty ? "Last name must be provided" : null,
            decoration: const InputDecoration(
              labelText: 'Last name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller.dobController,
            readOnly: true,
            onTap: () => _controller.selectDate(context),
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller.diagnosisController,
            validator: (value) =>
                value!.isEmpty ? "Diagnosis cannot be empty" : null,
            decoration: const InputDecoration(
              labelText: 'Diagnosis',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => _controller.submit(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text("Sign up"),
          ),
        ],
      ),
    );
  }
}

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final diagnosisController = TextEditingController();
  final dobController = TextEditingController();
  final activityController = FixedExtentScrollController();
  final selectedActivity = 0.obs;

  final List<String> activities = [
    'Basketball',
    'Cycling',
    'Boxing',
    'Drumming',
    'None',
  ];

  void updateActivity(int index) {
    selectedActivity.value = index;
  }

  // AuthService instance
  final _authService = AuthService();

  /// selectDate: Pulls up a date picker and sets dobController text
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  /// Now async: calls AuthService.registerWithEmail
  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    try {
      final user = await _authService.registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        dob: dobController.text,
        diagnosis: diagnosisController.text.trim(),
        activity: activities[selectedActivity.value],
      );
      if (user != null) {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        'Registration Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    diagnosisController.dispose();
    dobController.dispose();
    activityController.dispose();
    super.onClose();
  }
}
