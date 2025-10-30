import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/localized_data.dart';
import '../widgets/product_card.dart';
import '../widgets/featured_banner.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _navigateToDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
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
                              onDownload: () => _navigateToDetail(product),
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
          ],
        ),
      ),
    );
  }
}





