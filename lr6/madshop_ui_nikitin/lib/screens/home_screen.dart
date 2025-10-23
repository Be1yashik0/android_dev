import 'package:flutter/material.dart';
import 'package:madshop_ui_nikitin/widgets/product_card.dart';
import 'package:madshop_ui_nikitin/theme/colors.dart';
import 'product_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Set<int> _favorites = {};
  final Set<int> _cart = {};

  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'title': 'Лонгслив оверсайз с принтом Rakuzan',
      'description': '',
      'price': 3737.00,
      'imagePath': 'lib/assets/images/1.png',
    },
    {
      'id': 2,
      'title': 'Худи летнее широкий оверсайз',
      'description': '',
      'price': 5570.00,
      'imagePath': 'lib/assets/images/2.png',
    },
    {
      'id': 3,
      'title': 'Лонгслив с принтом scars',
      'description': '',
      'price': 1852.00,
      'imagePath': 'lib/assets/images/3.png',
    },
    {
      'id': 4,
      'title': 'Худи с двойным рукавом Джузо',
      'description': '',
      'price': 5276.00,
      'imagePath': 'lib/assets/images/4.png',
    },
    {
      'id': 5,
      'title': 'Лонгслив биглонг оверсайз с принтом аниме',
      'description': '',
      'price': 2546.00,
      'imagePath': 'lib/assets/images/5.png',
    },
    {
      'id': 6,
      'title': 'Лонгслив оверсайз',
      'description': '',
      'price': 2083.00,
      'imagePath': 'lib/assets/images/6.png',
    },
    {
      'id': 7,
      'title': 'Свитер y2k оверсайз',
      'description': '',
      'price': 2314.00,
      'imagePath': 'lib/assets/images/7.png',
    },
    {
      'id': 8,
      'title': 'Свитер y2k оверсайз',
      'description': '',
      'price': 2314.00,
      'imagePath': 'lib/assets/images/8.png',
    },
    {
      'id': 9,
      'title': 'Рубашка y2k оверсайз',
      'description': '',
      'price': 4116.00,
      'imagePath': 'lib/assets/images/9.png',
    },
    {
      'id': 10,
      'title': 'Лонгслив с двойным рукавом с принтом аниме',
      'description': '',
      'price': 2736.00,
      'imagePath': 'lib/assets/images/10.png',
    },
    {
      'id': 11,
      'title': 'Лонгслив с двойным рукавом оверсайз',
      'description': '',
      'price': 2546.00,
      'imagePath': 'lib/assets/images/11.png',
    },
    {
      'id': 12,
      'title': 'Лонгслив с двойным рукавом оверсайз',
      'description': '',
      'price': 2546.00,
      'imagePath': 'lib/assets/images/12.png',
    },
  ];

  void _toggleFavorite(int productId) {
    setState(() {
      if (_favorites.contains(productId)) {
        _favorites.remove(productId);
      } else {
        _favorites.add(productId);
      }
    });
  }

  void _toggleCart(int productId) {
    setState(() {
      if (_cart.contains(productId)) {
        _cart.remove(productId);
      } else {
        _cart.add(productId);
      }
    });
  }

  List<Widget> _getScreens() {
    return [
      ShopContent(
        products: _products,
        favorites: _favorites,
        cart: _cart,
        onFavoriteToggle: _toggleFavorite,
        onCartToggle: _toggleCart,
      ),
      FavoritesScreen(
        products: _products,
        favorites: _favorites,
        cart: _cart,
        onFavoriteToggle: _toggleFavorite,
        onCartToggle: _toggleCart,
      ),
      CartScreen(cartItems: _cart, products: _products),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreens()[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 0
                  ? 'lib/assets/images/homeS.png'
                  : 'lib/assets/images/home.png',
              width: 30,
              height: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 1
                  ? 'lib/assets/images/followS.png'
                  : 'lib/assets/images/follow.png',
              width: 35,
              height: 35,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 2
                  ? 'lib/assets/images/cartS.png'
                  : 'lib/assets/images/cart.png',
              width: 30,
              height: 30,
            ),
            label: '',
          ),
        ],
        selectedFontSize: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}

class ShopContent extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Set<int> favorites;
  final Set<int> cart;
  final Function(int) onFavoriteToggle;
  final Function(int) onCartToggle;

  const ShopContent({
    super.key,
    required this.products,
    required this.favorites,
    required this.cart,
    required this.onFavoriteToggle,
    required this.onCartToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Shop',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Clothing',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(200, 5, 63, 208),
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(200, 214, 217, 236),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
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
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
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
                    isFavorite: favorites.contains(product['id']),
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
