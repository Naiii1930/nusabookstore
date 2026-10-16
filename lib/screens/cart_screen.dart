
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String rupiah(double price) {
    return 'Rp ${price.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 70),
                  SizedBox(height: 12),
                  Text('Keranjang masih kosong'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return Card(
                        child: ListTile(
                          leading: Text(
                            item.book.icon,
                            style: const TextStyle(fontSize: 32),
                          ),
                          title: Text(item.book.title),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(rupiah(item.book.price)),
                              Text(
                                'Subtotal: ${rupiah(item.book.price * item.quantity)}',
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    context.read<CartProvider>()
                                      .removeItem(item.book),
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                ),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                onPressed: () =>
                                    context.read<CartProvider>()
                                      .addItem(item.book),
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        Text('Total Item: ${cart.totalItems}'),
                        const SizedBox(height: 8),
                        Text(
                          'Total Pembayaran: ${rupiah(cart.totalPrice)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          onPressed: () {
                            final total = rupiah(cart.totalPrice);

                            cart.clearCart();

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Checkout berhasil! Total pembayaran $total',
                                  ),
                                ),
                              );
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text('Checkout / Bayar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
