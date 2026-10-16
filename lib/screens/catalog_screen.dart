
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatelessWidget {
  CatalogScreen({super.key});

  final List<Book> books = const [
    Book(
      id: 1,
      title: 'Laskar Pelangi',
      author: 'Andrea Hirata',
      price: 85000,
      icon: '🌈',
    ),
    Book(
      id: 2,
      title: 'Bumi',
      author: 'Tere Liye',
      price: 95000,
      icon: '🌏',
    ),
    Book(
      id: 3,
      title: 'Laut Bercerita',
      author: 'Leila S. Chudori',
      price: 89000,
      icon: '🌊',
    ),
    Book(
      id: 4,
      title: 'Filosofi Teras',
      author: 'Henry Manampiring',
      price: 78000,
      icon: '🌿',
    ),
  ];

  String rupiah(double price) {
    return 'Rp ${price.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBookstore'),
        actions: [
          IconButton(
            tooltip: 'Ganti tema',
            onPressed: () =>
                context.read<ThemeProvider>().toggleTheme(),
            icon: Icon(
              theme.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (cart.totalItems > 0)
                    Positioned(
                      right: 3,
                      top: 3,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '${cart.totalItems}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Temukan Buku Favoritmu 📚',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Banyak cerita, satu tempat.'),
                  const SizedBox(height: 10),
                  Text('Koleksi Buku Pilihan'),
                ],
              ),
            ),
          ),
          ...books.map((book) => Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 75,
                        height: 95,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          book.icon,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(book.author),
                            const SizedBox(height: 7),
                            Text(
                              rupiah(book.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: () {
                                  context
                                      .read<CartProvider>()
                                      .addItem(book);

                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${book.title} ditambahkan ke keranjang',
                                        ),
                                        duration:
                                            const Duration(seconds: 1),
                                      ),
                                    );
                                },
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                ),
                                label: const Text(
                                  'Tambah ke Keranjang',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
