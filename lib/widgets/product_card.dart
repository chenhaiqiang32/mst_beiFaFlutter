import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDownload;
  final VoidCallback onDetails;

  const ProductCard({
    super.key,
    required this.product,
    required this.onDownload,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 产品图标
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getProductColor(product.name),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _getProductIcon(product.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 产品信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 产品图片
                SizedBox(
                  width: 80,
                  height: 60,
                  child: Row(
                    children: product.productImages.take(3).map((image) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.device_hub,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 操作按钮
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    '下载',
                    Colors.white,
                    Colors.black,
                    onDownload,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    '应用详情',
                    Colors.red,
                    Colors.white,
                    onDetails,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getProductColor(String productName) {
    switch (productName) {
      case 'ORIGINS':
        return Colors.orange;
      case 'GLORYFIT':
        return Colors.green;
      case 'MOSSTALK':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  String _getProductIcon(String productName) {
    switch (productName) {
      case 'ORIGINS':
        return 'O';
      case 'GLORYFIT':
        return 'G';
      case 'MOSSTALK':
        return 'M';
      default:
        return 'N';
    }
  }

  Widget _buildActionButton(
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: backgroundColor == Colors.white
              ? Border.all(color: Colors.black, width: 1)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}





