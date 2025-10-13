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
    // 获取屏幕宽度用于自适应
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Color(0x000000).withOpacity(0.08),
            blurRadius: screenWidth * 0.02,
            offset: Offset(0, screenWidth * 0.005),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: screenWidth * 0.04933, right: screenWidth * 0.02, bottom: screenWidth * 0.04266, left: screenWidth * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧内容区域
            Expanded(
              flex: 3,
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
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(screenWidth * 0.008),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(screenWidth * 0.008),
                          child: Image.asset(
                            'assets/images/beifa_logo.png',
                            width: screenWidth * 0.0426667,
                            height: screenWidth * 0.0426667,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        'NOVXX',
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
                    'AI音频眼镜',
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101828),
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.016),
                  // 产品描述
                  Text(
                    'AI 音频眼镜专属APP,支持影院…',
                    style: TextStyle(
                      fontSize: screenWidth * 0.026667,
                      color: Color(0xFF676C93),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenWidth * 0.032),
                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          '下载',
                          Colors.white,
                          Color(0xFF000000),
                          onDownload,
                          screenWidth,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.024),
                      Expanded(
                        child: _buildActionButton(
                          '应用详情',
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
            SizedBox(width: screenWidth * 0.04),
            // 右侧产品图片区域
            Expanded(
              flex: 2,
              child: Container(
                height: screenWidth * 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                  child: Stack(
                    children: [
                      // AI音频眼镜主体
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(screenWidth * 0.02),
                          ),
                        ),
                      ),
                      // 眼镜框架
                      Positioned(
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        top: screenWidth * 0.075,
                        bottom: screenWidth * 0.075,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
                          ),
                          child: Stack(
                            children: [
                              // 左镜片
                              Positioned(
                                left: screenWidth * 0.02,
                                top: screenWidth * 0.02,
                                child: Container(
                                  width: screenWidth * 0.0875,
                                  height: screenWidth * 0.0625,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                ),
                              ),
                              // 右镜片
                              Positioned(
                                right: screenWidth * 0.02,
                                top: screenWidth * 0.02,
                                child: Container(
                                  width: screenWidth * 0.0875,
                                  height: screenWidth * 0.0625,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                ),
                              ),
                              // 鼻梁
                              Positioned(
                                left: screenWidth * 0.125,
                                right: screenWidth * 0.125,
                                top: screenWidth * 0.0375,
                                bottom: screenWidth * 0.0375,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(screenWidth * 0.005),
                                  ),
                                ),
                              ),
                              // 左侧传感器
                              Positioned(
                                left: screenWidth * 0.005,
                                top: screenWidth * 0.05,
                                child: Container(
                                  width: screenWidth * 0.015,
                                  height: screenWidth * 0.015,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              // 右侧传感器
                              Positioned(
                                right: screenWidth * 0.005,
                                top: screenWidth * 0.05,
                                child: Container(
                                  width: screenWidth * 0.015,
                                  height: screenWidth * 0.015,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // NOVXX 品牌文字（在眼镜腿上）
                      Positioned(
                        right: screenWidth * 0.0375,
                        top: screenWidth * 0.1375,
                        child: Text(
                          'NOVXX',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
        height: screenWidth * 0.05333,
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






