import 'package:flutter/material.dart';
import 'package:madshop_ui_nikitin/widgets/product_card.dart';
import 'product_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Set<int> favorites;
  final Set<int> cart;
  final Function(int) onFavoriteToggle;
  final Function(int) onCartToggle;

  const FavoritesScreen({
    super.key,
    required this.products,
    required this.favorites,
    required this.cart,
    required this.onFavoriteToggle,
    required this.onCartToggle,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = products
        .where((product) => favorites.contains(product['id']))
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Favourites',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  return ProductCard(
                    title: product['title'] as String,
                    description: product['description'] as String,
                    price: product['price'] as double,
                    imagePath: product['imagePath'] as String,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            product: product,
                            cart: cart,
                            onCartToggle: onCartToggle,
                          ),
                        ),
                      );
                    },
                    isFavorite: true,
                    onFavoriteToggle: () =>
                        onFavoriteToggle(product['id'] as int),
                    isInCart: cart.contains(product['id']),
                    onCartToggle: () => onCartToggle(product['id'] as int),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
