import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_gaming_console/core/constants/app_colors.dart';
import 'package:uts_gaming_console/core/theme/neo_theme.dart';
import '../providers/cart_provider.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.neoYellow,
      ),
      backgroundColor: AppColors.background,
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.neoBlue,
                      border: NeoTheme.border,
                      shape: BoxShape.circle,
                      boxShadow: const [NeoTheme.shadow],
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Keranjang Kosong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai tambahkan produk favorit Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header Stats
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                padding: const EdgeInsets.all(16),
                decoration: NeoTheme.neoDecoration(color: AppColors.neoYellow),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cartProvider.itemCount} Item',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total Produk',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.black,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Rp ${cartProvider.totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total Harga',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: NeoTheme.neoDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Product Image
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: NeoTheme.borderThin,
                              ),
                              child: item.imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Image.network(
                                        item.imageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.image,
                                      color: AppColors.textHint,
                                      size: 40,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Rp ${item.price.toStringAsFixed(0)}/item',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Quantity Selector
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.neoYellow,
                                      borderRadius: BorderRadius.circular(6),
                                      border: NeoTheme.borderThin,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (item.quantity > 1) {
                                              cartProvider.updateItemQuantity(
                                                item.productId,
                                                item.quantity - 1,
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 30,
                                          child: Text(
                                            '${item.quantity}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Colors.black,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            cartProvider.updateItemQuantity(
                                              item.productId,
                                              item.quantity + 1,
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Right Section
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    cartProvider.removeItem(item.productId);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.neoPink,
                                      shape: BoxShape.circle,
                                      border: NeoTheme.borderThin,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Rp ${item.totalPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),  ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Checkout Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: const Border(top: BorderSide(color: Colors.black, width: 2.5)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Pembayaran',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${cartProvider.totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),  ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutPage(),
                            ),
                          );
                        },
                        style: NeoTheme.neoButtonStyle(backgroundColor: AppColors.neoGreen, foregroundColor: Colors.black),
                        child: const Text(
                          'Lanjut ke Checkout',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
