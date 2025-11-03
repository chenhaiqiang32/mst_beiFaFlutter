import 'package:flutter/material.dart';
import 'dart:io' show Platform, Directory, File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../services/localized_data.dart';

class ProductCard extends StatefulWidget {
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
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _fileExists = false; // 文件是否存在
  String? _filePath; // 文件路径
  static const MethodChannel _channel = MethodChannel('com.example.beifa_app_platform/file');

  @override
  void initState() {
    super.initState();
    _checkFileExists();
  }

  // 检查文件是否存在
  Future<void> _checkFileExists() async {
    if (kIsWeb || !Platform.isAndroid) return;
    
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) return;

      final url = widget.product.appInfo.downloadInfo.androidUrl;
      final providedName = widget.product.appInfo.downloadInfo.androidFileName;
      final fallbackName = Uri.tryParse(url)?.pathSegments.isNotEmpty == true
          ? Uri.parse(url).pathSegments.last
          : '${widget.product.name}.apk';
      final fileName = providedName == null || providedName.isEmpty ? fallbackName : providedName;
      
      final downloadDir = Directory('${dir.path}/Download');
      final filePath = '${downloadDir.path}/$fileName';
      final file = File(filePath);
      
      final exists = await file.exists();
      if (mounted) {
        setState(() {
          _fileExists = exists;
          if (exists) {
            _filePath = filePath;
          }
        });
      }
    } catch (e) {
      print('[ProductCard] Error checking file existence: $e');
    }
  }

  Future<void> _installApk() async {
    if (_filePath == null) return;
    try {
      if (Platform.isAndroid) {
        final file = File(_filePath!);
        if (await file.exists()) {
          try {
            await _channel.invokeMethod('installApk', {'filePath': _filePath!});
            print('[ProductCard] Successfully triggered APK installation');
          } on PlatformException catch (e) {
            print('[ProductCard] Failed to install APK: ${e.message}');
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
      }
    } catch (e) {
      print('[ProductCard] Failed to install APK: $e');
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

  void _handleDownload() {
    // 如果文件已存在，直接安装
    if (_fileExists && _filePath != null) {
      print('[ProductCard] File exists. Installing APK from $_filePath');
      _installApk();
      return;
    }
    // 否则调用原来的下载回调
    widget.onDownload();
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度用于自适应
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(18),
        image: widget.product.backgroundImageUrl != null
            ? DecorationImage(
                image: AssetImage(widget.product.backgroundImageUrl!),
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
                      widget.product.logoUrl,
                      width: screenWidth * 0.0426667,
                      height: screenWidth * 0.0426667,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  widget.product.name,
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
              widget.product.subtitle,
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
                message: widget.product.description,
                child: Text(
                  widget.product.description,
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
                    _fileExists 
                        ? LocalizedData.of(context).installButtonText 
                        : LocalizedData.of(context).downloadButtonText,
                    Colors.white,
                    Color(0xFF000000),
                    _handleDownload,
                    screenWidth,
                  ),
                ),
                SizedBox(width: screenWidth * 0.024),
                SizedBox(
                  width: screenWidth * 0.16,
                  child: _buildActionButton(
                    LocalizedData.of(context).detailsButtonText,
                    Color(0xFFD32D26),
                    Colors.white,
                    widget.onDetails,
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






