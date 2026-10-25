import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

/// UI login statis sesuai brief: tidak melakukan autentikasi/backend.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _continue() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.eggshell,
                AppColors.white,
                AppColors.babyBlue
              ]),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: AppLogo(size: 104),
                    ),
                    const SizedBox(height: 18),
                    const Text('Noted!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.sevenSeas)),
                    const SizedBox(height: 7),
                    const Text('Masuk untuk melanjutkan',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted)),
                    const SizedBox(height: 34),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                          hintText: 'Email'),
                    ),
                    const SizedBox(height: 13),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                        onPressed: _continue, child: const Text('Masuk')),
                    const SizedBox(height: 18),
                    const Row(children: [
                      Expanded(child: Divider(color: AppColors.line)),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('atau',
                              style: TextStyle(color: AppColors.muted))),
                      Expanded(child: Divider(color: AppColors.line))
                    ]),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: _continue,
                      icon: const Icon(Icons.g_mobiledata_rounded,
                          size: 28, color: AppColors.sevenSeas),
                      label: const Text('Masuk dengan Google',
                          style: TextStyle(color: AppColors.sevenSeas)),
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: const BorderSide(color: AppColors.line),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                    ),
                    const SizedBox(height: 18),
                    const Text('Mode demo · login tidak memakai autentikasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
