import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/data_service.dart';
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
  final DataService _dataService = DataService();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final products = _dataService.getProducts();
    setState(() {
      _products = products.toList(); // 显示所有产品，包括第一条
    });
  }

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
                          ..._products.map((product) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ProductCard(
                              product: product,
                              onDownload: () => _navigateToDetail(product),
                              onDetails: () => _navigateToDetail(product),
                            ),
                          )),
                          const SizedBox(height: 80), // 为底部固定的footer留出空间
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





