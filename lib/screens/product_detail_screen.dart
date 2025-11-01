import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/download_service.dart';
import '../models/product.dart';
import '../widgets/header_widget.dart';
import '../widgets/download_dialog.dart';
import '../services/localized_data.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final bool autoDownload; // 新增：是否自动触发下载

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.autoDownload = false, // 默认为 false
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _showDownloadDialog = false;
  bool _isDescriptionExpanded = false; // 应用介绍 展开/收起
  bool _isDescriptionOverflow = false; // 应用介绍是否超出行数

  @override
  void initState() {
    super.initState();
    // 如果设置了自动下载，在页面加载后自动触发下载
    if (widget.autoDownload) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 使用 withoutListen 避免在回调中触发 Provider 监听错误
        final currentProduct = LocalizedData
            .ofWithoutListen(context)
            .getProducts()
            .firstWhere((p) => p.id == widget.product.id, orElse: () => widget.product);
        _handleDownload(currentProduct);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always use product data from current locale by id to avoid stale texts
    final Product currentProduct = LocalizedData
        .of(context)
        .getProducts()
        .firstWhere((p) => p.id == widget.product.id, orElse: () => widget.product);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 247),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(
              showBackButton: true,
            ),
            _buildAppOverview(currentProduct),
            Expanded(
              child: SingleChildScrollView(
                child: _buildContentContainer(currentProduct),
              ),
            ),
            if (_showDownloadDialog)
              DownloadDialog(
                product: currentProduct,
                onClose: () => setState(() => _showDownloadDialog = false),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppOverview(Product product) {
    // 获取屏幕宽度用于自适应
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧：应用图标
          Container(
            width: screenWidth * 0.224,
            height: screenWidth * 0.224,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              child: Image.asset(
                  product.logoUrl,
                  width: screenWidth * 0.224,
                  height: screenWidth * 0.224,
                  fit: BoxFit.cover,
                )
            ),
          ),
          SizedBox(width: screenWidth * 0.046667),
          // 右侧：文本和按钮区域（上下对齐）
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 应用信息 - 文本内容
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: screenWidth * 0.050666,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF101828),
                        height: 1.6,
                      ),
                    ),
                    // SizedBox(height: screenWidth * 0.01),
                    Text(
                      product.subSubtitle,
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: const Color(0xFF808080),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.02),
                // 下载按钮 - 垂直排列
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildDownloadButton(
                      LocalizedData.of(context).androidDownloadButtonText,
                      const Color(0xFFD32D26),
                      Colors.white,
                      () => _handleDownload(product),
                      screenWidth,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentContainer(Product product) {
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
          _buildAppStats(product),
          _buildPreviewSection(product),
          _buildFeatureTabs(product),
          _buildAppIntroduction(product),
          _buildInformationSection(product),
          _buildNewFeaturesSection(),
        ],
      ),
    );
  }

  Widget _buildAppStats(Product product) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667, vertical: screenWidth * 0.053333),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  LocalizedData.of(context).statsLanguageLabel,
                  product.appInfo.supportedLanguages.first,
                  product.appInfo.supportedLanguages[1],
                  screenWidth,
                ),
              ),
              _buildVerticalDivider(screenWidth),
              Expanded(
                child: _buildStatItem(
                  LocalizedData.of(context).statsSizeLabel,
                  product.appInfo.size.split(' ').first,
                  LocalizedData.of(context).statsMbUnit,
                  screenWidth,
                ),
              ),
              _buildVerticalDivider(screenWidth),
              Expanded(
                child: _buildStatItem(
                  LocalizedData.of(context).statsCurrentVersionLabel,
                  product.appInfo.version,
                  LocalizedData.of(context).statsLatestLabel,
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

  Widget _buildPreviewSection(Product product) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.042667),
            child: Text(
            LocalizedData.of(context).previewTitle,
            style: TextStyle(
              fontSize: screenWidth * 0.04266,
              fontWeight: FontWeight.bold,
              color:const Color(0xFF101828)
            ),
          ),
        ),

        SizedBox(
          height: screenWidth * 0.528,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.032),
            itemCount: product.appInfo.screenshots.length > 0 
                ? product.appInfo.screenshots.length 
                : 4, // 如果没有截图，显示4个占位符
            itemBuilder: (context, index) {
              return Container(
                width: screenWidth * 0.244,
                margin: EdgeInsets.only(right: screenWidth * 0.042667),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.042667),
                  child: product.appInfo.screenshots.length > index
                      ? Image.asset(
                          product.appInfo.screenshots[index],
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

  Widget _buildFeatureTabs(Product product) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabs = product.appInfo.features.take(4).toList(); // 取前4个功能
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667, vertical: screenWidth * 0.021333),
          child: Row(
            children: tabs.map((tab) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.010667),
                width: screenWidth * 0.17733, // 固定宽度 133px
                height: screenWidth * 0.07, // 固定高度 54px
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

  Widget _buildAppIntroduction(Product product) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.042667),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      LocalizedData.of(context).appIntroTitle,
                      style: TextStyle(
                        fontSize: screenWidth * 0.042666,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF101828),
                      ),
                    ),
                  ),
                  if (_isDescriptionOverflow)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDescriptionExpanded = !_isDescriptionExpanded;
                        });
                      },
                      child: Text(
                        _isDescriptionExpanded ? LocalizedData.of(context).collapseText : LocalizedData.of(context).expandText,
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          color: Colors.blue,
                          decoration: TextDecoration.none,
                          height: 1.2,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: screenWidth * 0.02133),
              _buildExpandableText(
                text: product.description,
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  color: const Color(0xFF808080),
                  height: 1.2,
                ),
                trimLines: 5,
                onOverflowChanged: (overflow) {
                  if (overflow != _isDescriptionOverflow) {
                    setState(() {
                      _isDescriptionOverflow = overflow;
                    });
                  }
                },
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

  // 可展开/收起文本（超过 trimLines 行时显示“展开/收起”）
  Widget _buildExpandableText({
    required String text,
    required TextStyle style,
    required int trimLines,
    ValueChanged<bool>? onOverflowChanged,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: trimLines,
          textDirection: TextDirection.ltr,
          ellipsis: LocalizedData.of(context).textEllipsisChar,
        )..layout(maxWidth: constraints.maxWidth);

        final bool isOverflow = textPainter.didExceedMaxLines;
        if (onOverflowChanged != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onOverflowChanged(isOverflow);
          });
        }

        return Text(
          text,
          style: style,
          maxLines: _isDescriptionExpanded ? null : trimLines,
          overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget _buildInformationSection(Product product) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.042667),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizedData.of(context).infoTitle,
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
                        _buildInfoItem(LocalizedData.of(context).statsSizeLabel, product.appInfo.size, screenWidth),
                        SizedBox(height: screenWidth * 0.053333),
                        _buildInfoItem(LocalizedData.of(context).infoAppRatingLabel, product.appInfo.appRating, screenWidth),
                        SizedBox(height: screenWidth * 0.053333),
                        _buildInfoItem(LocalizedData.of(context).infoLastUpdateLabel, product.appInfo.lastUpdate, screenWidth),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.053333),
                  // 右列
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem(LocalizedData.of(context).infoDeveloperLabel, product.appInfo.developer, screenWidth),
                        SizedBox(height: screenWidth * 0.053333),
                        _buildInfoItem(LocalizedData.of(context).infoLanguageLabel, product.appInfo.informationLanguage, screenWidth),
                        SizedBox(height: screenWidth * 0.053333),
                        _buildInfoItem(LocalizedData.of(context).infoSupplierLabel, product.appInfo.developer, screenWidth),
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
                LocalizedData.of(context).accessibilityTitle,
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
                      LocalizedData.of(context).accessibilityDescription,
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: const Color(0xFF808080),
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.021333),
                  // GestureDetector(
                  //   onTap: () {
                  //     // 处理"进一步了解"点击事件
                  //   },
                  //   child: Text(
                  //     '进一步了解',
                  //     style: TextStyle(
                  //       fontSize: screenWidth * 0.032,
                  //       color: Colors.blue,
                  //       decoration: TextDecoration.none,
                  //       height: -0.8,
                  //     ),
                  //   ),
                  // ),
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
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.026666,
          vertical: screenWidth * 0.016,
        ),
        constraints: BoxConstraints(
          minWidth: screenWidth * 0.18666,
          minHeight: screenWidth * 0.0666,
        ),
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

  void _handleDownload(Product product) {
    print('[DetailScreen] Download clicked for product=${product.id} name=${product.name}');
    if (kIsWeb) {
      print('[DetailScreen] Web platform detected. Showing snackbar.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前平台不支持下载，仅在手机上可用')),
      );
      return;
    }
    if (Platform.isIOS) {
      print('[DetailScreen] Detected iOS. Opening App Store url=${product.appInfo.downloadInfo.iosUrl}');
      DownloadService().openIOSAppStore(product.appInfo.downloadInfo.iosUrl);
      return;
    }
    if (Platform.isAndroid) {
      print('[DetailScreen] Detected Android. Showing DownloadDialog for url=${product.appInfo.downloadInfo.androidUrl}');
      setState(() {
        _showDownloadDialog = true;
      });
      return;
    }
    print('[DetailScreen] Unsupported platform. Showing snackbar.');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('当前平台不支持下载，仅在手机上可用')),
    );
  }
}





