import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform, Directory, File;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';
import '../services/localized_data.dart';

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
  double _downloadProgress = 0.0;
  bool _started = false;
  bool _downloadCompleted = false;
  String? _filePath;
  static const MethodChannel _channel = MethodChannel('com.example.beifa_app_platform/file');

  @override
  void initState() {
    super.initState();
    _maybeStartDownload();
  }

  Future<void> _maybeStartDownload() async {
    if (kIsWeb) {
      print('[DownloadDialog] Web platform detected. Skip download start.');
      return;
    }
    if (!Platform.isAndroid) {
      print('[DownloadDialog] Non-Android platform detected. Skip download start.');
      return;
    }
    if (_started) return;
    _started = true;
    try {
      // For Android 10+, we use app-specific external directory which doesn't require storage permission
      final dir = await getExternalStorageDirectory();
      print('[DownloadDialog] getExternalStorageDirectory -> ${dir?.path}');
      if (dir == null) {
        print('[DownloadDialog] Failed to get external storage directory');
        return;
      }

      final url = widget.product.appInfo.downloadInfo.androidUrl;
      final providedName = widget.product.appInfo.downloadInfo.androidFileName;
      final fallbackName = Uri.tryParse(url)?.pathSegments.isNotEmpty == true
          ? Uri.parse(url).pathSegments.last
          : '${widget.product.name}.apk';
      final fileName = providedName == null || providedName.isEmpty ? fallbackName : providedName;
      
      // Use Download subdirectory for better organization
      final downloadDir = await Directory('${dir.path}/Download').create(recursive: true);
      final filePath = '${downloadDir.path}/$fileName';
      print('[DownloadDialog] Start download. url=$url fileName=$fileName filePath=$filePath');

      final dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (!mounted) return;
          if (total <= 0) return;
          final p = received / total;
          if ((p * 100).toInt() % 2 == 0) {
            print('[DownloadDialog] Progress ${(p * 100).toStringAsFixed(0)}% ($received/$total)');
          }
          setState(() {
            _downloadProgress = received / total;
          });
        },
      );

      if (!mounted) return;
      setState(() {
        _downloadProgress = 1.0;
        _downloadCompleted = true;
        _filePath = filePath;
      });
      print('[DownloadDialog] Download completed. File saved to: $filePath');
    } catch (e) {
      print('[DownloadDialog] Download error: $e');
      if (!mounted) return;
      setState(() {
        _downloadProgress = 0.0;
      });
    }
  }

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
                        LocalizedData.of(context).downloadDialogTitle,
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
                                widget.product.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.037333,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.021333),
                              // Icon(
                              //   Icons.edit,
                              //   color: Colors.grey,
                              //   size: screenWidth * 0.042667,
                              // ),
                            ],
                          ),
                          SizedBox(height: screenWidth * 0.010667),
                          Row(
                            children: [
                              Text(
                                '${LocalizedData.of(context).fileSizeLabel}: ${widget.product.appInfo.size}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenWidth * 0.032,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.021333),
                              // Container(
                              //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.016, vertical: screenWidth * 0.001333),
                              //   decoration: BoxDecoration(
                              //     color: const Color(0xFF1A1A1A), // 深色背景
                              //     border: Border.all(
                              //       color: const Color(0xFFFFB74D), // 金色边框
                              //       width: 1,
                              //     ),
                              //     borderRadius: BorderRadius.circular(screenWidth * 0.08), // 更圆的胶囊形状
                              //   ),
                              //   child: Text(
                              //     '未知',
                              //     style: TextStyle(
                              //       color: const Color(0xFFFFB74D), // 金色文字
                              //       fontSize: screenWidth * 0.026667,
                              //     ),
                              //   ),
                              // ),
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
                      LocalizedData.of(context).recommendedAppsTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.042667,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.032),
                    ...LocalizedData.of(context)
                        .getProducts()
                        .where((p) => p.id != widget.product.id)
                        .take(3)
                        .map((app) => _buildRecommendedApp(app, screenWidth)),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.053333),
              ],
            ),
          ),
        ),
        // 遮罩层（仅在下载中且进度未达到100%时显示）
        if (!_downloadCompleted && _downloadProgress < 1.0)
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(screenWidth * 0.04),
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
                                    '${LocalizedData.of(context).downloadedProgressPrefix}${(_downloadProgress * 100).toInt()}${LocalizedData.of(context).downloadedProgressSuffix}',
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        // 下载成功提示（在遮罩层外，可以点击）
        if (_downloadCompleted)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.042667),
                  padding: EdgeInsets.all(screenWidth * 0.042667),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A), // 深色背景
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    border: Border.all(
                      color: Colors.green, // 绿色边框表示成功
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 成功图标
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: screenWidth * 0.106667,
                      ),
                      SizedBox(height: screenWidth * 0.032),
                      // 成功标题
                      Text(
                        LocalizedData.of(context).downloadSuccessTitle,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: screenWidth * 0.042667,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.021333),
                      // 文件路径提示
                      Text(
                        LocalizedData.of(context).downloadSuccessMessage,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.032,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenWidth * 0.016),
                      // 文件路径
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.021333),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(screenWidth * 0.016),
                        ),
                        child: SelectableText(
                          _filePath ?? '',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: screenWidth * 0.026667,
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.032),
                      // 操作按钮
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 稍后安装按钮
                          ElevatedButton.icon(
                            onPressed: () {
                              // 只关闭下载成功提示框，不关闭整个对话框
                              setState(() {
                                _downloadCompleted = false;
                              });
                            },
                            icon: Icon(Icons.schedule, size: screenWidth * 0.037333),
                            label: Text(
                              LocalizedData.of(context).buttonInstallLater,
                              style: TextStyle(fontSize: screenWidth * 0.032),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.042667,
                                vertical: screenWidth * 0.021333,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.032),
                          // 安装应用按钮
                          ElevatedButton.icon(
                            onPressed: _installApk,
                            icon: Icon(Icons.install_mobile, size: screenWidth * 0.037333),
                            label: Text(
                              LocalizedData.of(context).buttonInstallApk,
                              style: TextStyle(fontSize: screenWidth * 0.032),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.042667,
                                vertical: screenWidth * 0.021333,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _installApk() async {
    if (_filePath == null) return;
    try {
      if (Platform.isAndroid) {
        // 在Android上，使用平台通道安装APK
        final file = File(_filePath!);
        if (await file.exists()) {
          try {
            await _channel.invokeMethod('installApk', {'filePath': _filePath!});
            print('[DownloadDialog] Successfully triggered APK installation');
          } on PlatformException catch (e) {
            print('[DownloadDialog] Failed to install APK: ${e.message}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('安装失败: ${e.message ?? e.code}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('文件不存在'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        // 其他平台使用url_launcher
        final fileUri = Uri.file(_filePath!);
        if (await canLaunchUrl(fileUri)) {
          await launchUrl(fileUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      print('[DownloadDialog] Failed to install APK: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('安装失败: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
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
          ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.021333),
            child: Image.asset(
              app.logoUrl,
              width: screenWidth * 0.106667,
              height: screenWidth * 0.106667,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: screenWidth * 0.032),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.037333,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenWidth * 0.010667),
                Text(
                  app.subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.032,
                  ),
                ),
                SizedBox(height: screenWidth * 0.010667),
                Row(
                  children: [
                    Text(
                      LocalizedData.of(context).versionLabel,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.026667,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.010667),
                    Text(
                      app.appInfo.version,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.026667,
                      ),
                    ),
                  ],
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
              LocalizedData.of(context).downloadButtonText,
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

  
}





