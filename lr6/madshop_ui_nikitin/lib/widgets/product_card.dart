import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String imagePath;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final bool isInCart;
  final VoidCallback onCartToggle;

  const ProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.isInCart,
    required this.onCartToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(100),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                  ),
                ),
                Positioned(
                  top: 1,
                  left: 1,
                  child: IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_border
                          : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 30,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: onCartToggle,
                    child: Image.asset(
                      isInCart
                          ? 'lib/assets/images/added.png'
                          : 'lib/assets/images/add.png',
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\₽${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
