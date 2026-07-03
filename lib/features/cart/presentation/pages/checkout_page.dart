import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uts_gaming_console/core/constants/app_colors.dart';
import 'package:uts_gaming_console/core/theme/neo_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../providers/cart_provider.dart';
import 'payment_success_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isProcessing = false;
  int _currentStep = 0;
  String _selectedPaymentMethod = 'emoney'; // 'emoney' or 'simulation'

  void _processCheckout() async {
    final cartProvider = context.read<CartProvider>();
    final amount = cartProvider.totalPrice;

    if (_selectedPaymentMethod == 'emoney') {
      setState(() {
        _isProcessing = true;
      });

      // Generate unique transaction ID
      final trxId = 'TX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      const merchantEmail = 'recipient@example.com';

      if (kIsWeb) {
        final webUri = Uri.parse(
          'http://localhost:52130/?amount=$amount'
          '&recipient=$merchantEmail'
          '&trx_id=$trxId'
          '&callback=${Uri.encodeComponent('http://localhost:55486/')}'
        );
        debugPrint('Launching E-Money Web Link: $webUri');
        try {
          await launchUrl(webUri, mode: LaunchMode.platformDefault);
          setState(() {
            _isProcessing = false;
          });
        } catch (e) {
          setState(() {
            _isProcessing = false;
          });
          debugPrint('Error launching web link: $e');
        }
        return;
      }

      const callbackUrl = 'ecommerce://callback';
      
      final deepLinkUri = Uri.parse(
        'emoney://pay?amount=$amount'
        '&recipient=$merchantEmail'
        '&trx_id=$trxId'
        '&callback=${Uri.encodeComponent(callbackUrl)}'
      );

      debugPrint('Launching E-Money Deep Link: $deepLinkUri');

      try {
        await launchUrl(deepLinkUri, mode: LaunchMode.externalApplication);
        setState(() {
          _isProcessing = false;
        });
      } catch (e) {
        setState(() {
          _isProcessing = false;
        });
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('E-Money Wallet Tidak Ditemukan'),
              content: const Text(
                'Aplikasi E-Money Wallet belum terpasang di perangkat Anda. '
                'Silakan pasang aplikasi dompet digital untuk melanjutkan pembayaran.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          );
        }
      }
    } else if (_selectedPaymentMethod == 'qris') {
      setState(() {
        _isProcessing = false;
      });

      final trxId = 'TX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      const merchantEmail = 'recipient@example.com';
      const callbackUrl = 'ecommerce://callback';
      final qrisPayload = 'emoney://pay?amount=$amount&recipient=$merchantEmail&trx_id=$trxId&callback=${Uri.encodeComponent(callbackUrl)}';
      final qrCodeUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=${Uri.encodeComponent(qrisPayload)}';

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black, width: 2.5),
            ),
            title: const Row(
              children: [
                Icon(Icons.qr_code_scanner, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Bayar QRIS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Buka aplikasi Doran Pay di HP Anda, masuk ke menu "Scan QRIS" lalu scan kode di bawah:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    qrCodeUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Total Tagihan: Rp ${amount.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID Transaksi: $trxId',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final uri = Uri.parse(qrCodeUrl);
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    debugPrint('Gagal membuka link QRIS: $e');
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text('Buka / Simpan Gambar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text('Batal'),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        _isProcessing = true;
      });

      // Simulasi proses pembayaran
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessPage(
              onSuccess: () {
                // Clear cart setelah sukses
                context.read<CartProvider>().clearCart();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isProcessing) return false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout Pesanan', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black)),
          centerTitle: true,
          automaticallyImplyLeading: !_isProcessing,
          backgroundColor: AppColors.neoYellow,
          elevation: 0,
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
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tidak Ada Item di Keranjang',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                Column(
                  children: [
                    // Progress Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStepIndicator(0, 'Review'),
                          Container(
                            width: 40,
                            height: 2,
                            color: _currentStep >= 1
                                ? Colors.black
                                : AppColors.textHint,
                          ),
                          _buildStepIndicator(1, 'Bayar'),
                        ],
                      ),
                    ),
                    // Header Checkout Info
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: NeoTheme.neoDecoration(color: AppColors.neoBlue),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ringkasan Pesanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
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
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Produk',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rp ${cartProvider.totalPrice.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
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
                    // Item List Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Detail Produk',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Item List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: cartProvider.items.length,
                        itemBuilder: (context, index) {
                          final item = cartProvider.items[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: NeoTheme.neoDecoration(small: true),
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
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
                                          size: 35,
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Qty: ${item.quantity}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${item.price.toStringAsFixed(0)}/item',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${item.totalPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
                // Total & Checkout Button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(top: BorderSide(color: Colors.black, width: 2.5)),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Payment Method Selector
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: NeoTheme.radius,
                              border: NeoTheme.border,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Text(
                                    'Pilih Metode Pembayaran',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                RadioListTile<String>(
                                  value: 'emoney',
                                  groupValue: _selectedPaymentMethod,
                                  activeColor: AppColors.neoGreen,
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text(
                                    'E-Money (Wallet)',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: const Text(
                                    'App-to-App payment integration',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  secondary: const Icon(Icons.account_balance_wallet, color: AppColors.primary),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedPaymentMethod = val!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  value: 'simulation',
                                  groupValue: _selectedPaymentMethod,
                                  activeColor: AppColors.neoGreen,
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text(
                                    'Simulasi COD / COD',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: const Text(
                                    'Simulasi checkout langsung',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  secondary: const Icon(Icons.payment, color: AppColors.textSecondary),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedPaymentMethod = val!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  value: 'qris',
                                  groupValue: _selectedPaymentMethod,
                                  activeColor: AppColors.neoGreen,
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text(
                                    'QRIS (Scan & Pay)',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: const Text(
                                    'Tampilkan kode QR untuk discan',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  secondary: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedPaymentMethod = val!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
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
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _isProcessing ? null : _processCheckout,
                            style: NeoTheme.neoButtonStyle(backgroundColor: AppColors.neoPink, foregroundColor: Colors.black),
                            child: _isProcessing
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Proses Pembayaran',
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppColors.neoGreen : AppColors.background,
            shape: BoxShape.circle,
            border: NeoTheme.borderThin,
            boxShadow: isActive ? const [NeoTheme.shadowSmall] : [],
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.black : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.black : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
