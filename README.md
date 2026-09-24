# Flutter Shop

A starter e-commerce app built with Flutter, ready for **App Store** and **Google Play**.

## Features

- Product catalog with images
- Shopping cart (add / remove / quantity)
- Checkout screen
- In-app purchases via `in_app_purchase` (StoreKit on iOS, Google Play Billing on Android)

## Getting started

```bash
flutter pub get
flutter run
```

## In-app purchase setup

### iOS (App Store)
1. Create an app in App Store Connect.
2. Create a consumable in-app purchase product (e.g. `shop_order_total`).
3. In Xcode: open `ios/Runner.xcworkspace`, enable the **In-App Purchase** capability.
4. Test with a Sandbox Apple ID.

### Android (Google Play)
1. Create an app in Google Play Console.
2. Create a one-time product with the same ID.
3. Upload a signed AAB to internal testing.
4. Test with a license tester account.

## Notes

- The checkout currently uses a single product ID for the whole order. For real shops, create per-product IDs or use a backend to verify purchases server-side.
- Replace mock products in `lib/data/mock_products.dart` with your real catalog (or connect an API).
