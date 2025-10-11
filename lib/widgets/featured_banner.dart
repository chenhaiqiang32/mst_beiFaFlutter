import 'package:flutter/material.dart';
import '../models/product.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度用于自适应
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.5; // 高度为屏幕宽度的50%
    
    return Container(
      width: double.infinity, // 铺满宽度
      height: bannerHeight,
      child: Stack(
        children: [
          // 背景图片
          Positioned.fill(
            child: Image.asset(
              'assets/images/featured_banner_bg.png',
              fit: BoxFit.fitWidth, // 适应宽度，保持图片宽度完整
              alignment: Alignment.topCenter, // 顶部居中对齐
              errorBuilder: (context, error, stackTrace) {
                // 如果图片加载失败，显示渐变背景
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF8F4FF),
                        Color(0xFFF0E8FF),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // 文字内容 - 垂直居中，左侧定位
          Positioned(
            left: screenWidth * 0.05, // 左边距为屏幕宽度的5%
            top: 0,
            bottom: 0,
            right: screenWidth * 0.4,  // 右边距为屏幕宽度的40%，为右侧图标留空间
            child: Center( // 垂直居中
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '贝发 | 应用下载',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06, // 字体大小为屏幕宽度的6%
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: bannerHeight * 0.03), // 间距为横幅高度的3%
                  Text(
                    '一站式获取全系列官方应用,安全下载,快速开启专属服务',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035, // 字体大小为屏幕宽度的3.5%
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
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





