import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/save_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2A1F),
        title: const Text('SETTINGS', style: TextStyle(letterSpacing: 3)),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Sound Effects'),
            value: SaveService.soundOn,
            activeColor: const Color(0xFF6B8E23),
            onChanged: (v) async {
              await SaveService.setSoundOn(v);
              setState(() {});
            },
          ),
          SwitchListTile(
            title: const Text('Music'),
            value: SaveService.musicOn,
            activeColor: const Color(0xFF6B8E23),
            onChanged: (v) async {
              await SaveService.setMusicOn(v);
              setState(() {});
            },
          ),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.login),
            title: Text(AuthService.instance.isSignedIn ? 'Sign Out' : 'Sign In with Google'),
            onTap: () async {
              if (AuthService.instance.isSignedIn) {
                await AuthService.instance.signOut();
              } else {
                await AuthService.instance.signInWithGoogle();
              }
              setState(() {});
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Restore Purchases'),
            onTap: () {},
          ),
          const Divider(color: Colors.white12),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Iron Front: Last Defense'),
            subtitle: Text('Version 1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Privacy Policy'),
            onTap: () {
              // TODO: Open privacy policy URL
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Terms of Service'),
            onTap: () {
              // TODO: Open ToS URL
            },
          ),
        ],
      ),
    );
  }
}
