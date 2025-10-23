import 'package:flutter/material.dart';
import 'package:madshop_ui_nikitin/theme/colors.dart';

class CartScreen extends StatefulWidget {
  final Set<int> cartItems;
  final List<Map<String, dynamic>> products;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.products,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<int, int> _itemQuantities = {};

  @override
  void initState() {
    super.initState();
    for (var itemId in widget.cartItems) {
      _itemQuantities[itemId] = _itemQuantities[itemId] ?? 1;
    }
  }

  @override
  void didUpdateWidget(covariant CartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartItems != oldWidget.cartItems) {
      setState(() {
        for (var itemId in widget.cartItems) {
          if (!_itemQuantities.containsKey(itemId)) {
            _itemQuantities[itemId] = 1;
          }
        }
        _itemQuantities.removeWhere((id, _) => !widget.cartItems.contains(id));
      });
    }
  }

  void _removeItem(int productId) {
    setState(() {
      widget.cartItems.remove(productId);
      _itemQuantities.remove(productId);
    });
  }

  void _updateQuantity(int productId, int delta) {
    setState(() {
      int newQuantity = (_itemQuantities[productId] ?? 1) + delta;
      if (newQuantity > 0) {
        _itemQuantities[productId] = newQuantity;
      } else {
        _itemQuantities.remove(productId);
        widget.cartItems.remove(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts = widget.products
        .where((product) => widget.cartItems.contains(product['id']))
        .toList();
    double total = cartProducts.fold(0.0, (sum, p) {
      int quantity = _itemQuantities[p['id']] ?? 1;
      return sum + (p['price'] as double) * quantity;
    });

    if (cartProducts.isEmpty) {
      return SafeArea(
        child: const Center(
          child: Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Cart',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 202, 217, 249),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    widget.cartItems.length.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                children: cartProducts.map((product) {
                  int quantity = _itemQuantities[product['id']] ?? 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,

                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    product['imagePath'] as String,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withAlpha(128),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              left: 1,
                              child: GestureDetector(
                                onTap: () => _removeItem(product['id'] as int),
                                child: Image.asset(
                                  'lib/assets/images/rm.png',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['title'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Size: M',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),

                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\₽${(product['price'] as double).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _updateQuantity(
                                          product['id'] as int,
                                          -1,
                                        ),
                                        child: Image.asset(
                                          'lib/assets/images/min.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Color.fromARGB(
                                            255,
                                            200,
                                            209,
                                            252,
                                          ),
                                        ),

                                        child: Text(
                                          '$quantity',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(width: 5),

                                      GestureDetector(
                                        onTap: () => _updateQuantity(
                                          product['id'] as int,
                                          1,
                                        ),
                                        child: Image.asset(
                                          'lib/assets/images/plus.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  'Total \₽${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  width: 150,

                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Checkout (in development)'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),

                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
