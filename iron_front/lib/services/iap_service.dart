import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../config/app_config.dart';
import 'save_service.dart';

/// Google Play Billing wrapper. Handles subscriptions and one-time purchases.
class IapService {
  IapService._();
  static final IapService instance = IapService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  List<ProductDetails> products = [];
  bool available = false;

  static const Set<String> _productIds = {
    AppConfig.subMonthlyId,
    AppConfig.subYearlyId,
    AppConfig.iapRemoveAds,
    AppConfig.iapCoins1000,
    AppConfig.iapCoins5000,
    AppConfig.iapBattlePass,
  };

  Future<void> init() async {
    if (kIsWeb) return;
    available = await _iap.isAvailable();
    if (!available) return;

    _sub = _iap.purchaseStream.listen(_onPurchaseUpdate, onDone: () => _sub?.cancel());

    final response = await _iap.queryProductDetails(_productIds);
    products = response.productDetails;
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) {
        await _grantEntitlement(p);
      }
      if (p.pendingCompletePurchase) {
        await _iap.completePurchase(p);
      }
    }
  }

  Future<void> _grantEntitlement(PurchaseDetails p) async {
    switch (p.productID) {
      case AppConfig.subMonthlyId:
      case AppConfig.subYearlyId:
        await SaveService.setSubscribed(true);
        await SaveService.setAdsRemoved(true);
        break;
      case AppConfig.iapRemoveAds:
        await SaveService.setAdsRemoved(true);
        break;
      case AppConfig.iapCoins1000:
        await SaveService.addCoins(1000);
        break;
      case AppConfig.iapCoins5000:
        await SaveService.addCoins(5000);
        break;
      case AppConfig.iapBattlePass:
        await SaveService.setBattlePassOwned(true);
        break;
    }
  }

  Future<void> buy(String productId) async {
    final p = products.where((x) => x.id == productId).firstOrNull;
    if (p == null) return;
    final purchaseParam = PurchaseParam(productDetails: p);
    if (productId == AppConfig.iapCoins1000 || productId == AppConfig.iapCoins5000) {
      await _iap.buyConsumable(purchaseParam: purchaseParam);
    } else {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> restorePurchases() async {
    if (kIsWeb) return;
    await _iap.restorePurchases();
  }

  void dispose() {
    _sub?.cancel();
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
