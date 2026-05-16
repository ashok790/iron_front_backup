import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../services/iap_service.dart';
import '../services/save_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2A1F),
        title: const Text('ARMORY', style: TextStyle(letterSpacing: 3)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${SaveService.coins}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('COIN PACKS'),
          _shopItem('1,000 Coins', '\$0.99', Icons.monetization_on, AppConfig.iapCoins1000),
          _shopItem('5,000 Coins', '\$4.99', Icons.monetization_on, AppConfig.iapCoins5000),
          const SizedBox(height: 20),
          _section('UPGRADES'),
          _shopItem('Remove Ads', '\$3.99', Icons.block, AppConfig.iapRemoveAds),
          _shopItem('Battle Pass Season 1', '\$4.99', Icons.military_tech, AppConfig.iapBattlePass),
        ],
      ),
    );
  }

  Widget _section(String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(label,
            style: const TextStyle(
                color: Color(0xFF6B8E23),
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                fontSize: 13)),
      );

  Widget _shopItem(String name, String price, IconData icon, String productId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2A1F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF6B8E23).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Text(name,
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              await IapService.instance.buy(productId);
              if (mounted) setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B8E23),
              foregroundColor: Colors.white,
            ),
            child: Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
