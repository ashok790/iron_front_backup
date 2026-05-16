import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF2D3F1F), Color(0xFF0D1117)],
            radius: 1.2,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _ctrl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF6B8E23), width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield, size: 100, color: Color(0xFF6B8E23)),
                ),
                const SizedBox(height: 28),
                const Text(
                  'IRON FRONT',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 6,
                  ),
                ),
                const Text(
                  'LAST DEFENSE',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B8E23),
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(color: Color(0xFF6B8E23)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
