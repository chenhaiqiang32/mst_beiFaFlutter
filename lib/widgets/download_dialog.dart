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
  bool _fileExists = false; // 主应用文件是否存在
  static const MethodChannel _channel = MethodChannel('com.example.beifa_app_platform/file');
  
  // 推荐应用的下载状态
  final Map<String, double> _recommendedDownloads = {};
  final Map<String, bool> _recommendedCompleted = {};
  final Map<String, String> _recommendedFilePaths = {}; // 存储推荐应用的下载文件路径
  final Map<String, bool> _recommendedShowSuccess = {}; // 控制是否显示成功弹窗
  final Map<String, bool> _recommendedFileExists = {}; // 推荐应用文件是否存在

  @override
  void initState() {
    super.initState();
    _checkFileExists();
    _maybeStartDownload();
  }

  // 检查主应用文件是否存在
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
            _downloadCompleted = true;
          }
        });
      }
    } catch (e) {
      print('[DownloadDialog] Error checking file existence: $e');
    }
  }

  // 检查推荐应用文件是否存在
  Future<void> _checkRecommendedFileExists(Product app) async {
    if (kIsWeb || !Platform.isAndroid) return;
    if (_recommendedFileExists.containsKey(app.id)) return; // 已检查过
    
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) return;

      final url = app.appInfo.downloadInfo.androidUrl;
      final providedName = app.appInfo.downloadInfo.androidFileName;
      final fallbackName = Uri.tryParse(url)?.pathSegments.isNotEmpty == true
          ? Uri.parse(url).pathSegments.last
          : '${app.name}.apk';
      final fileName = providedName == null || providedName.isEmpty ? fallbackName : providedName;
      
      final downloadDir = Directory('${dir.path}/Download');
      final filePath = '${downloadDir.path}/$fileName';
      final file = File(filePath);
      
      final exists = await file.exists();
      if (mounted) {
        setState(() {
          _recommendedFileExists[app.id] = exists;
          if (exists) {
            _recommendedFilePaths[app.id] = filePath;
            _recommendedCompleted[app.id] = true;
            _recommendedDownloads[app.id] = 1.0;
          }
        });
      }
    } catch (e) {
      print('[DownloadDialog] Error checking recommended file existence: $e');
    }
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
    // 如果文件已存在，不开始下载
    if (_fileExists) {
      print('[DownloadDialog] File already exists. Skip download.');
      return;
    }
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
        if (!_downloadCompleted && !_fileExists && _downloadProgress < 1.0)
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
        // 下载成功提示（在遮罩层外，可以点击）- 仅在刚刚下载完成时显示
        if (_downloadCompleted && _filePath != null && _filePath!.isNotEmpty && !_fileExists)
          _buildSuccessDialog(screenWidth, _filePath ?? '', _installApk, () {
            setState(() {
              _downloadCompleted = false;
            });
          }),
        // 推荐应用下载成功提示
        ...LocalizedData.of(context)
            .getProducts()
            .where((p) => p.id != widget.product.id)
            .take(3)
            .map((app) {
              if (_recommendedShowSuccess[app.id] == true) {
                return _buildSuccessDialog(
                  screenWidth,
                  _recommendedFilePaths[app.id] ?? '',
                  () => _installRecommendedApk(app.id),
                  () {
                    setState(() {
                      _recommendedShowSuccess[app.id] = false;
                    });
                  },
                );
              }
              return const SizedBox.shrink();
            }),
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

  Future<void> _downloadRecommendedApp(Product app) async {
    if (kIsWeb || !Platform.isAndroid) {
      return;
    }
    
    // 如果已经在下载或已完成，不重复下载
    if (_recommendedDownloads.containsKey(app.id) || _recommendedCompleted[app.id] == true) {
      return;
    }
    
    try {
      // For Android 10+, we use app-specific external directory which doesn't require storage permission
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        print('[DownloadDialog] Failed to get external storage directory for recommended app');
        return;
      }

      final url = app.appInfo.downloadInfo.androidUrl;
      final providedName = app.appInfo.downloadInfo.androidFileName;
      final fallbackName = Uri.tryParse(url)?.pathSegments.isNotEmpty == true
          ? Uri.parse(url).pathSegments.last
          : '${app.name}.apk';
      final fileName = providedName == null || providedName.isEmpty ? fallbackName : providedName;
      
      // Use Download subdirectory for better organization
      final downloadDir = await Directory('${dir.path}/Download').create(recursive: true);
      final filePath = '${downloadDir.path}/$fileName';
      print('[DownloadDialog] Start download recommended app. url=$url fileName=$fileName filePath=$filePath');

      final dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (!mounted) return;
          if (total <= 0) return;
          final p = received / total;
          if ((p * 100).toInt() % 2 == 0) {
            print('[DownloadDialog] Recommended app progress ${(p * 100).toStringAsFixed(0)}% ($received/$total)');
          }
          setState(() {
            _recommendedDownloads[app.id] = p;
          });
        },
      );

      if (!mounted) return;
      setState(() {
        _recommendedDownloads[app.id] = 1.0;
        _recommendedCompleted[app.id] = true;
        _recommendedFilePaths[app.id] = filePath;
        _recommendedShowSuccess[app.id] = true; // 显示成功弹窗
      });
      print('[DownloadDialog] Recommended app download completed. File saved to: $filePath');
    } catch (e) {
      print('[DownloadDialog] Recommended app download error: $e');
      if (!mounted) return;
      setState(() {
        _recommendedDownloads.remove(app.id);
      });
    }
  }

  Future<void> _installRecommendedApk(String appId) async {
    final filePath = _recommendedFilePaths[appId];
    if (filePath == null || filePath.isEmpty) return;
    try {
      if (Platform.isAndroid) {
        final file = File(filePath);
        if (await file.exists()) {
          try {
            await _channel.invokeMethod('installApk', {'filePath': filePath});
            print('[DownloadDialog] Successfully triggered recommended APK installation');
          } on PlatformException catch (e) {
            print('[DownloadDialog] Failed to install recommended APK: ${e.message}');
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
      print('[DownloadDialog] Failed to install recommended APK: $e');
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

  Widget _buildSuccessDialog(double screenWidth, String filePath, VoidCallback onInstall, VoidCallback onLater) {
    return Positioned.fill(
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
                    filePath,
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
                      onPressed: onLater,
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
                      onPressed: onInstall,
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
    );
  }

  Widget _buildRecommendedApp(Product app, double screenWidth) {
    // 检查文件是否存在（如果还没检查过）
    if (!_recommendedFileExists.containsKey(app.id)) {
      _checkRecommendedFileExists(app);
    }
    
    final downloadProgress = _recommendedDownloads[app.id] ?? 0.0;
    final isCompleted = _recommendedCompleted[app.id] ?? false;
    final fileExists = _recommendedFileExists[app.id] ?? false;
    final isDownloading = downloadProgress > 0.0 && downloadProgress < 1.0;
    
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
          // 根据状态显示不同的UI
          if (fileExists || (isCompleted && _recommendedFilePaths.containsKey(app.id)))
            // 文件已存在 - 显示"去安装"按钮
            GestureDetector(
              onTap: () => _installRecommendedApk(app.id),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.032, vertical: screenWidth * 0.016),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.green, width: 1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                child: Text(
                  LocalizedData.of(context).installButtonText,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: screenWidth * 0.032,
                  ),
                ),
              ),
            )
          else if (isDownloading)
            // 下载中状态 - 显示进度条
            Container(
              width: screenWidth * 0.32,
              height: screenWidth * 0.064,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border.all(color: const Color(0xFF4A90E2), width: 1),
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                child: Stack(
                  children: [
                    // 进度填充
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: (screenWidth * 0.32) * downloadProgress,
                        height: screenWidth * 0.064,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(screenWidth * 0.04),
                            bottomLeft: Radius.circular(screenWidth * 0.04),
                            topRight: downloadProgress >= 1.0 ? Radius.circular(screenWidth * 0.04) : Radius.circular(0),
                            bottomRight: downloadProgress >= 1.0 ? Radius.circular(screenWidth * 0.04) : Radius.circular(0),
                          ),
                        ),
                      ),
                    ),
                    // 进度文字
                    Center(
                      child: Text(
                        '${(downloadProgress * 100).toInt()}%',
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
            )
          else
            // 未开始下载 - 显示下载按钮
            GestureDetector(
              onTap: () => _downloadRecommendedApp(app),
              child: Container(
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
            ),
        ],
      ),
    );
  }

  
}





