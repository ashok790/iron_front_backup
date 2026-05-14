import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../services/iap_service.dart';
import '../services/save_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final isSubscribed = SaveService.isSubscribed;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2A1F),
        title: const Text('COMMANDER\'S PASS', style: TextStyle(letterSpacing: 3)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B8E23), Color(0xFF2D3F1F)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium, color: Colors.amber, size: 60),
                  const SizedBox(height: 12),
                  const Text('COMMANDER\'S PASS',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3)),
                  const SizedBox(height: 8),
                  const Text('Unlock the full Iron Front experience',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('BENEFITS',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 10),
            _benefit(Icons.block, 'Ad-free gameplay'),
            _benefit(Icons.monetization_on, '2× daily coin rewards'),
            _benefit(Icons.trending_up, '+20% XP boost'),
            _benefit(Icons.palette, 'Exclusive monthly skins'),
            _benefit(Icons.star, 'Priority support'),
            const SizedBox(height: 24),
            if (isSubscribed)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 12),
                    Text('You are subscribed', style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            else ...[
              _planCard(
                title: 'MONTHLY',
                price: '\$2.99/mo',
                subtitle: 'Cancel anytime',
                productId: AppConfig.subMonthlyId,
              ),
              const SizedBox(height: 12),
              _planCard(
                title: 'YEARLY',
                price: '\$24.99/yr',
                subtitle: 'Save 30% — includes bonus skin',
                productId: AppConfig.subYearlyId,
                highlight: true,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => IapService.instance.restorePurchases(),
                child: const Text('Restore Purchases'),
              ),
            ],
            const SizedBox(height: 30),
            const Text(
              'Subscriptions auto-renew unless cancelled in Google Play. '
              'Payment charged to your Google Play account.',
              style: TextStyle(color: Colors.white38, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B8E23), size: 22),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _planCard({
    required String title,
    required String price,
    required String subtitle,
    required String productId,
    bool highlight = false,
  }) {
    return GestureDetector(
      onTap: () async {
        await IapService.instance.buy(productId);
        if (mounted) setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFF6B8E23).withOpacity(0.2) : const Color(0xFF1B2A1F),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: highlight ? Colors.amber : const Color(0xFF6B8E23),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2)),
                      if (highlight) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('BEST VALUE',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Text(price,
                style: const TextStyle(
                    color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
