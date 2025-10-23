import 'package:flutter/material.dart';
import 'package:madshop_ui_nikitin/theme/colors.dart';

class ProductScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final Set<int> cart;
  final Function(int) onCartToggle;

  const ProductScreen({
    super.key,
    required this.product,
    required this.cart,
    required this.onCartToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isInCart = cart.contains(product['id']);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(product['imagePath'] as String),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(128),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['title'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product['description'] as String,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              '\₽${(product['price'] as double).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onCartToggle(product['id'] as int);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart ? Colors.red : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isInCart ? 'Remove from Cart' : 'Add to Cart',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
