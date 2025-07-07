import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/services/auth_service.dart';

class AuthGatewayPage extends StatefulWidget {
  const AuthGatewayPage({super.key});

  @override
  State<AuthGatewayPage> createState() => _AuthGatewayPageState();
}

class _AuthGatewayPageState extends State<AuthGatewayPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _checkLoginStatus());
  }

  void _checkLoginStatus() {
    final isLoggedIn = _authService.isLoggedIn();

    final targetRoute = isLoggedIn ? '/home' : '/login';

    if (mounted) {
      Get.offAllNamed(targetRoute);
    }
  }

  // If the phone is underperforming (CPU throttling, etc.), show them a progress indicator
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}