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
  Product? _featuredProduct;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final products = _dataService.getProducts();
    setState(() {
      _products = products.where((p) => !p.isFeatured).toList();
      _featuredProduct = products.firstWhere((p) => p.isFeatured);
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const FeaturedBanner(),
                    const SizedBox(height: 16),
                    ..._products.map((product) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ProductCard(
                        product: product,
                        onDownload: () => _navigateToDetail(product),
                        onDetails: () => _navigateToDetail(product),
                      ),
                    )),
                    const SizedBox(height: 32),
                    const FooterWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





