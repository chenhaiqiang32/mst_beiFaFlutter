import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/header_widget.dart';
import '../widgets/download_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _showDownloadDialog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F3FF),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            _buildAppOverview(),
            Expanded(
              child: SingleChildScrollView(
                child: _buildContentContainer(),
              ),
            ),
            if (_showDownloadDialog)
              DownloadDialog(
                product: widget.product,
                onClose: () => setState(() => _showDownloadDialog = false),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppOverview() {
    // 获取屏幕宽度用于自适应
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 应用图标
            Container(
              width: screenWidth * 0.224,
              height: screenWidth * 0.224,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  child: widget.product.productImages.isNotEmpty
                      ? Image.asset(
                          widget.product.productImages.first,
                          width: screenWidth * 0.224,
                          height: screenWidth * 0.224,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: screenWidth * 0.224,
                          height: screenWidth * 0.224,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image,
                            size: screenWidth * 0.1,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
            ),
            SizedBox(width: screenWidth * 0.046667),
            // 应用信息 - 左侧文本内容
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.050666,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF101828),
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    widget.product.subtitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      color: const Color(0xFF808080),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            // 下载按钮 - 右侧按钮区域
            Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDownloadButton(
                      'iOS下载',
                      Colors.white,
                      const Color(0xFFD32D26),
                      () => _handleIOSDownload(),
                      screenWidth,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    _buildDownloadButton(
                      'Android下载',
                      const Color(0xFFD32D26),
                      Colors.white,
                      () => _handleAndroidDownload(),
                      screenWidth,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenWidth * 0.042667),
          topRight: Radius.circular(screenWidth * 0.042667),
        ),
      ),
      child: Column(
        children: [
          _buildAppStats(),
          _buildPreviewSection(),
          _buildFeatureTabs(),
          _buildAppIntroduction(),
          _buildInformationSection(),
          _buildNewFeaturesSection(),
        ],
      ),
    );
  }

  Widget _buildAppStats() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667, vertical: screenWidth * 0.053333),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '语言',
                  widget.product.appInfo.supportedLanguages.first,
                  '+ 12种语言',
                  screenWidth,
                ),
              ),
              _buildVerticalDivider(screenWidth),
              Expanded(
                child: _buildStatItem(
                  '大小',
                  widget.product.appInfo.size.split(' ').first,
                  'MB',
                  screenWidth,
                ),
              ),
              _buildVerticalDivider(screenWidth),
              Expanded(
                child: _buildStatItem(
                  '当前版本',
                  widget.product.appInfo.version,
                  '最新',
                  screenWidth,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667),
          height: 1,
          color: const Color(0xFFE5E7EB),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, String subtitle, double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.02666,
            color: const Color(0xFFA0A0A0),
            height: 1.2,
          ),
        ),
        SizedBox(height: screenWidth * 0.032),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.04266,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF808080),
            height: 1.2,
          ),
        ),
        SizedBox(height: screenWidth * 0.032),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: screenWidth * 0.032,
            color: const Color(0xFF9CA3AF),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(double screenWidth) {
    return Container(
      height: screenWidth * 0.0613333,
      width: 1,
      color: const Color(0xFFE5E7EB),
    );
  }

  Widget _buildPreviewSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.042667),
          child: Text(
            '预览',
            style: TextStyle(
              fontSize: screenWidth * 0.04266,
              fontWeight: FontWeight.bold,
              color:const Color(0xFF101828)
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.04266),
        SizedBox(
          height: screenWidth * 0.528,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.032),
            itemCount: widget.product.appInfo.screenshots.length > 0 
                ? widget.product.appInfo.screenshots.length 
                : 4, // 如果没有截图，显示4个占位符
            itemBuilder: (context, index) {
              return Container(
                width: screenWidth * 0.48,
                margin: EdgeInsets.only(right: screenWidth * 0.042667),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: screenWidth * 0.026667,
                      offset: Offset(0, screenWidth * 0.005333),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.042667),
                  child: widget.product.appInfo.screenshots.length > index
                      ? Image.asset(
                          widget.product.appInfo.screenshots[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: Icon(
                              Icons.phone_android,
                              size: screenWidth * 0.16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: screenWidth * 0.037333),
      ],
    );
  }

  Widget _buildFeatureTabs() {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabs = widget.product.appInfo.features.take(4).toList(); // 取前4个功能
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667, vertical: screenWidth * 0.021333),
          child: Row(
            children: tabs.map((tab) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.010667),
                  width: screenWidth * 0.17733, // 133px 换算
                  height: screenWidth * 0.072, // 54px 换算
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8), // #F8F8F8
                    borderRadius: BorderRadius.circular(27), // 27px 换算
                  ),
                  child: Center(
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: const Color(0xFF808080), // #808080
                        fontSize: screenWidth * 0.032, // 24px 换算
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: screenWidth * 0.064), // 48px 换算
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667),
          height: 1,
          color: const Color(0xFFE5E7EB),
        ),
      ],
    );
  }

  Widget _buildAppIntroduction() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.042667),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '应用介绍',
                style: TextStyle(
                  fontSize: screenWidth * 0.042666,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101828),
                ),
              ),
              SizedBox(height: screenWidth * 0.02133),
              Text(
                widget.product.description,
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  color: const Color(0xFF808080),
                  height: 1.2,
                ),
              ),
              // SizedBox(height: screenWidth * 0.01666),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667),
          height: 1,
          color: const Color(0xFFE5E7EB),
        ),
      ],
    );
  }

  Widget _buildInformationSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.042667),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '信息',
                style: TextStyle(
                  fontSize: screenWidth * 0.0426,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF374151),
                ),
              ),
              SizedBox(height: screenWidth * 0.024),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左列
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem('大小', widget.product.appInfo.size, screenWidth),
                        SizedBox(height: screenWidth * 0.053333),
                        _buildInfoItem('应用分级', widget.product.appInfo.appRating, screenWidth),
                        SizedBox(height: screenWidth * 0.053333),
                        _buildInfoItem('最近更新', widget.product.appInfo.lastUpdate, screenWidth),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.053333),
                  // 右列
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem('开发者', widget.product.appInfo.developer, screenWidth),
                        SizedBox(height: screenWidth * 0.053333),
                        _buildInfoItem('语言', widget.product.appInfo.supportedLanguages.join('、'), screenWidth),
                        SizedBox(height: screenWidth * 0.053333),
                        _buildInfoItem('供应商', widget.product.appInfo.developer, screenWidth),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667),
          height: 1,
          color: const Color(0xFFE5E7EB),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.02666,
            color: const Color(0xFF9CA3AF),
            height: 1.2,
          ),
        ),
        SizedBox(height: screenWidth * 0.010667),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.032,
            color: const Color(0xFF374151),
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildNewFeaturesSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.042667),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Text(
                '辅助功能',
                style: TextStyle(
                  fontSize: screenWidth * 0.0426666,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101828),
                ),
              ),
              SizedBox(height: screenWidth * 0.021333),
              // 描述文本和链接行
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '开发者尚未表明此 App 支持哪些辅助功能。',
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: const Color(0xFF808080),
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.021333),
                  GestureDetector(
                    onTap: () {
                      // 处理"进一步了解"点击事件
                    },
                    child: Text(
                      '进一步了解',
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: Colors.blue,
                        decoration: TextDecoration.none,
                        height: -0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 底部下划线 - 移出有内边距的容器
        Container(
          width: double.infinity,
          height: 1,
          color: const Color(0xFFE5E7EB),
        ),
        SizedBox(height: screenWidth * 0.090666),
      ],
    );
  }

  Widget _buildDownloadButton(
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onTap,
    double screenWidth,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.18666,
        height: screenWidth * 0.0666,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: backgroundColor == Colors.white
              ? Border.all(color: const Color(0xFFD32D26), width: 1)
              : null,
          borderRadius: BorderRadius.circular(screenWidth * 0.010667),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: screenWidth * 0.0266,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _handleIOSDownload() {
    // 处理iOS下载
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('iOS下载功能')),
    );
  }

  void _handleAndroidDownload() {
    setState(() {
      _showDownloadDialog = true;
    });
  }
}





