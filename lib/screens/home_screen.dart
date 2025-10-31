import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/product.dart';
import '../services/localized_data.dart';
import '../widgets/product_card.dart';
import '../widgets/featured_banner.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/download_dialog.dart';
import '../services/download_service.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showDownloadDialog = false;
  Product? _downloadingProduct;

  void _navigateToDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _handleDownload(Product product) {
    print('[HomeScreen] Download clicked for product=${product.id} name=${product.name}');
    if (kIsWeb) {
      print('[HomeScreen] Web platform detected. Showing snackbar.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前平台不支持下载，仅在手机上可用')),
      );
      return;
    }
    if (Platform.isIOS) {
      print('[HomeScreen] Detected iOS. Opening App Store url=${product.appInfo.downloadInfo.iosUrl}');
      DownloadService().openIOSAppStore(product.appInfo.downloadInfo.iosUrl);
      return;
    }
    if (Platform.isAndroid) {
      print('[HomeScreen] Detected Android. Showing DownloadDialog for url=${product.appInfo.downloadInfo.androidUrl}');
      setState(() {
        _downloadingProduct = product;
        _showDownloadDialog = true;
      });
      return;
    }
    print('[HomeScreen] Unsupported platform. Showing snackbar.');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('当前平台不支持下载，仅在手机上可用')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> products = LocalizedData.of(context).getProducts();
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const HeaderWidget(),
                const FeaturedBanner(),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...products.map((product) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ProductCard(
                              product: product,
                              onDownload: () => _handleDownload(product),
                              onDetails: () => _navigateToDetail(product),
                            ),
                          )),
                          const SizedBox(height: 10), // 为底部固定的footer留出空间
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const FooterWidget(),
            if (_showDownloadDialog && _downloadingProduct != null)
              DownloadDialog(
                product: _downloadingProduct!,
                onClose: () => setState(() {
                  _showDownloadDialog = false;
                  _downloadingProduct = null;
                }),
              ),
          ],
        ),
      ),
    );
  }
}





