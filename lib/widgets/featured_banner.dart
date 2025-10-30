import 'package:flutter/material.dart';
import '../services/data_service.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度用于自适应
    final screenWidth = MediaQuery.of(context).size.width;
    final dataService = DataService();
    final title = dataService.featuredBannerTitle;
    final subtitle = dataService.featuredBannerSubtitle;
    
    return Container(
      width: double.infinity, // 铺满宽度
      child: Stack(
        children: [
          // 背景图片 - 宽度铺满，高度自适应
          Image.asset(
            'assets/images/featured_banner_bg.png',
            width: double.infinity,
            fit: BoxFit.fitWidth, // 适应宽度，保持图片宽高比
            errorBuilder: (context, error, stackTrace) {
              // 如果图片加载失败，显示渐变背景，使用默认高度
              return Container(
                width: double.infinity,
                height: screenWidth * 0.5,
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
          // 文字内容 - 垂直居中，左侧定位
          Positioned.fill(
            left: screenWidth * 0.05, // 左边距为屏幕宽度的5%
            child: Center( // 垂直居中
              child: Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth * 0.42, // 最大宽度为屏幕宽度的32%
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 使用最小尺寸
                    mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: screenWidth * 0.0426, // 字体大小为屏幕宽度的6%
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF101828),
                          height: 1, // 行高设置为1，文字垂直居中
                        ),
                        maxLines: null, // 允许多行
                        overflow: TextOverflow.visible, // 超出时换行
                      ),
                      SizedBox(height: screenWidth * 0.015), // 间距为屏幕宽度的1.5%
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: screenWidth * 0.02133, // 字体大小为屏幕宽度的3.5%
                          color: Color(0xFF667085),
                          height: 1.4,
                        ),
                        maxLines: null, // 允许多行
                        overflow: TextOverflow.visible, // 超出时换行
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}





