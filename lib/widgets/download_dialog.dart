import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/data_service.dart';

class DownloadDialog extends StatefulWidget {
  final Product product;
  final VoidCallback onClose;

  const DownloadDialog({
    super.key,
    required this.product,
    required this.onClose,
  });

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  double _downloadProgress = 0.07; // 7% 下载进度
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度用于自适应
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Stack(
      children: [
        // 内容层
        Center(
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.053333),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 44, 45),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // 标题栏
              Container(
                padding: EdgeInsets.all(screenWidth * 0.042667),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        '下载',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.03733,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: widget.onClose,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: screenWidth * 0.044,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 下载项目
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667),
                child: Row(
                  children: [
                    Container(
                      width: screenWidth * 0.106667,
                      height: screenWidth * 0.106667,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(screenWidth * 0.021333),
                      ),
                      child: Icon(
                        Icons.android,
                        color: Colors.white,
                        size: screenWidth * 0.064,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.032),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.product.appInfo.downloadInfo.androidFileName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.037333,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.021333),
                              Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: screenWidth * 0.042667,
                              ),
                            ],
                          ),
                          SizedBox(height: screenWidth * 0.010667),
                          Row(
                            children: [
                              Text(
                                '文件大小: ${widget.product.appInfo.size}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenWidth * 0.032,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.021333),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.016, vertical: screenWidth * 0.001333),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A), // 深色背景
                                  border: Border.all(
                                    color: const Color(0xFFFFB74D), // 金色边框
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(screenWidth * 0.08), // 更圆的胶囊形状
                                ),
                                child: Text(
                                  '未知',
                                  style: TextStyle(
                                    color: const Color(0xFFFFB74D), // 金色文字
                                    fontSize: screenWidth * 0.026667,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.053333),
              // 推荐应用
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '推荐应用',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.042667,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.032),
                    ..._dataService.getRecommendedApps().map((app) => _buildRecommendedApp(app, screenWidth)),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.053333),
              ],
            ),
          ),
        ),
        // 遮罩层
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // 下载进度条显示在遮罩层上
                  Positioned(
                    top: screenWidth * 0.533333, // 调整位置到合适的地方
                    left: screenWidth * 0.042667,
                    right: screenWidth * 0.042667,
                    child: Center(
                      child: Container(
                        height: screenWidth * 0.08, // 进度条高度
                        width: screenWidth * 0.6, // 进度条宽度
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A), // 深色背景
                          border: Border.all(
                            color: const Color(0xFF4A90E2), // 蓝色边框
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(screenWidth * 0.04), // 圆角
                        ),
                        child: Stack(
                          children: [
                            // 进度填充
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: (screenWidth * 0.6) * _downloadProgress, // 根据进度计算宽度
                                height: screenWidth * 0.08, // 确保高度与容器一致
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A), // 稍亮的填充色
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(screenWidth * 0.04),
                                    bottomLeft: Radius.circular(screenWidth * 0.04),
                                    topRight: _downloadProgress >= 1.0 ? Radius.circular(screenWidth * 0.04) : Radius.circular(0),
                                    bottomRight: _downloadProgress >= 1.0 ? Radius.circular(screenWidth * 0.04) : Radius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                            // 进度文字
                            Center(
                              child: Text(
                                '已下载${(_downloadProgress * 100).toInt()}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.w500,
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
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedApp(Product app, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.032),
      padding: EdgeInsets.all(screenWidth * 0.032),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(screenWidth * 0.021333),
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.106667,
            height: screenWidth * 0.106667,
            decoration: BoxDecoration(
              color: _getAppColor(app.name),
              borderRadius: BorderRadius.circular(screenWidth * 0.021333),
            ),
            child: Center(
              child: Text(
                _getAppIcon(app.name),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.032,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.032),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${app.name} ${app.subtitle}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.037333,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenWidth * 0.010667),
                Text(
                  app.description,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.032,
                  ),
                ),
                SizedBox(height: screenWidth * 0.010667),
                Text(
                  app.appInfo.developer,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.026667,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.032),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.032, vertical: screenWidth * 0.016),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.blue, width: 1),
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
            child: Text(
              '下载',
              style: TextStyle(
                color: Colors.blue,
                fontSize: screenWidth * 0.032,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAppColor(String appName) {
    switch (appName) {
      case '起点读书':
        return Colors.red;
      case '番茄畅听':
        return Colors.orange;
      case '西瓜视频':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _getAppIcon(String appName) {
    switch (appName) {
      case '起点读书':
        return '起点';
      case '番茄畅听':
        return '🍅';
      case '西瓜视频':
        return '🍉';
      default:
        return 'A';
    }
  }
}





