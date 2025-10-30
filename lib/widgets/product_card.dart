import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/data_service.dart';

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
    // 获取屏幕宽度用于自适应
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(18),
        image: product.backgroundImageUrl != null
            ? DecorationImage(
                image: AssetImage(product.backgroundImageUrl!),
                fit: BoxFit.cover,
                opacity: 1,
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: screenWidth * 0.04933, right: screenWidth * 0.02, bottom: screenWidth * 0.04266, left: screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOVXX 品牌标识
            Row(
              children: [
                Container(
                  width: screenWidth * 0.0426667,
                  height: screenWidth * 0.0426667,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.008),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.008),
                    child: Image.asset(
                      product.logoUrl,
                      width: screenWidth * 0.0426667,
                      height: screenWidth * 0.0426667,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03733,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1D1F),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.03),
            // 产品标题
            Text(
              product.subtitle,
              style: TextStyle(
                fontSize: screenWidth * 0.032,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101828),
                height: 1.2,
              ),
            ),
            SizedBox(height: screenWidth * 0.016),
            // 产品描述
            SizedBox(
              width: screenWidth * 0.408,
              child: Tooltip(
                message: product.description,
                child: Text(
                  product.description,
                  style: TextStyle(
                    fontSize: screenWidth * 0.026667,
                    color: Color(0xFF676C93),
                    height: 1.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.032),
            // 操作按钮
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.16,
                  child: _buildActionButton(
                    DataService().downloadButtonText,
                    Colors.white,
                    Color(0xFF000000),
                    onDownload,
                    screenWidth,
                  ),
                ),
                SizedBox(width: screenWidth * 0.024),
                SizedBox(
                  width: screenWidth * 0.16,
                  child: _buildActionButton(
                    DataService().detailsButtonText,
                    Color(0xFFD32D26),
                    Colors.white,
                    onDetails,
                    screenWidth,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildActionButton(
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onTap,
    double screenWidth,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenWidth * 0.06,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: backgroundColor == Colors.white
              ? Border.all(color: Colors.grey[600]!, width: 1)
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: screenWidth * 0.026667,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}






