import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Handles in-app purchases for both App Store and Google Play.
///
/// Setup required:
/// - iOS: create an In-App Purchase product in App Store Connect, then
///   enable In-App Purchase capability in Xcode.
/// - Android: create a product in Google Play Console and link a
///   Google Play service account for server verification.
class PurchaseService {
  PurchaseService._();
  static final PurchaseService instance = PurchaseService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<bool> buyConsumable(String productId, double amount) async {
    final available = await _iap.isAvailable();
    if (!available) {
      debugPrint('In-app purchases not available on this device.');
      return false;
    }

    final response = await _iap.queryProductDetails({productId});
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      debugPrint('Product $productId not found in the store.');
      return false;
    }

    final product = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: product);

    final completer = Completer<bool>();
    _subscription = _iap.purchaseStream.listen((purchases) {
      for (final purchase in purchases) {
        if (purchase.productID == productId) {
          if (purchase.status == PurchaseStatus.purchased ||
              purchase.status == PurchaseStatus.restored) {
            _iap.completePurchase(purchase);
            completer.complete(true);
          } else if (purchase.status == PurchaseStatus.error) {
            completer.complete(false);
          }
        }
      }
    });

    final started = await _iap.buyConsumable(purchaseParam: purchaseParam);
    if (!started) return false;
    return completer.future;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
