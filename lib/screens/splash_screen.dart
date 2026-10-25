import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.eggshell, AppColors.babyBlue, AppColors.matcha],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(size: 104),
                const SizedBox(height: 22),
                const Text('Noted!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.sevenSeas, letterSpacing: -.7)),
                const SizedBox(height: 10),
                const Text('Simpan ide, rencana, dan cerita harianmu.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.sevenSeas, fontSize: 14)),
                const SizedBox(height: 54),
                SizedBox(
                  width: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(minHeight: 5, backgroundColor: AppColors.white, color: AppColors.viridian),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
