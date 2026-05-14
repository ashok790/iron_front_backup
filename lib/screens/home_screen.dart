import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'shop_screen.dart';
import 'subscription_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B2A1F), Color(0xFF0D1117)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.shield, size: 80, color: Color(0xFF6B8E23)),
                const SizedBox(height: 12),
                const Text(
                  'IRON FRONT',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                const Text(
                  'LAST DEFENSE',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B8E23),
                    letterSpacing: 6,
                  ),
                ),
                const Spacer(),
                _MenuButton(
                  label: 'DEPLOY',
                  icon: Icons.play_arrow,
                  primary: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  ),
                ),
                const SizedBox(height: 14),
                _MenuButton(
                  label: 'COMMANDER\'S PASS',
                  icon: Icons.workspace_premium,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                  ),
                ),
                const SizedBox(height: 14),
                _MenuButton(
                  label: 'ARMORY',
                  icon: Icons.shopping_bag,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ShopScreen()),
                  ),
                ),
                const SizedBox(height: 14),
                _MenuButton(
                  label: 'SETTINGS',
                  icon: Icons.settings,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'v1.0.0 • Tap DEPLOY to begin',
                  style: TextStyle(color: Colors.white24, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 26),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? const Color(0xFF6B8E23) : const Color(0xFF2D3F1F),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: primary ? Colors.white24 : const Color(0xFF6B8E23),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
