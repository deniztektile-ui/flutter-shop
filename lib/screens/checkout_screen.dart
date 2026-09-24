import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';
import 'purchase_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _loading = false;

  Future<void> _buy() async {
    setState(() => _loading = true);
    final success = await PurchaseService.instance.buyConsumable('shop_order_total', context.read<CartProvider>().totalPrice);
    if (!mounted) return;
    setState(() => _loading = false);
    if (success) {
      context.read<CartProvider>().clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed or cancelled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = context.watch<CartProvider>().totalPrice;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Total: €${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            const Text('Payment is processed via App Store / Google Play in-app purchases.'),
            const Spacer(),
            ElevatedButton(
              onPressed: _loading ? null : _buy,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Pay with App Store / Google Play'),
            ),
          ],
        ),
      ),
    );
  }
}
