import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  final Dio _dio = Dio();

  Future<void> downloadAndroidApp(String url, String fileName, BuildContext context) async {
    try {
      // 请求存储权限
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showErrorDialog(context, '需要存储权限才能下载应用');
        return;
      }

      // 获取下载目录
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        _showErrorDialog(context, '无法获取存储目录');
        return;
      }

      final filePath = '${directory.path}/$fileName';
      
      // 显示下载进度
      _showDownloadProgress(context, url, filePath);
      
    } catch (e) {
      _showErrorDialog(context, '下载失败: $e');
    }
  }

  Future<void> openIOSAppStore(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('打开App Store失败: $e');
    }
  }

  void _showDownloadProgress(BuildContext context, String url, String filePath) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DownloadProgressDialog(
        url: url,
        filePath: filePath,
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('错误'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class _DownloadProgressDialog extends StatefulWidget {
  final String url;
  final String filePath;

  const _DownloadProgressDialog({
    required this.url,
    required this.filePath,
  });

  @override
  State<_DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  double _progress = 0.0;
  bool _isDownloading = true;
  String _status = '准备下载...';

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  Future<void> _startDownload() async {
    try {
      final dio = Dio();
      
      await dio.download(
        widget.url,
        widget.filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
              _status = '已下载${(_progress * 100).toInt()}%';
            });
          }
        },
      );

      setState(() {
        _isDownloading = false;
        _status = '下载完成';
      });

      // 延迟关闭对话框
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
          _showInstallDialog();
        }
      });

    } catch (e) {
      setState(() {
        _isDownloading = false;
        _status = '下载失败: $e';
      });
    }
  }

  void _showInstallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('下载完成'),
        content: const Text('应用已下载完成，是否立即安装？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('稍后安装'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _installApp();
            },
            child: const Text('立即安装'),
          ),
        ],
      ),
    );
  }

  void _installApp() {
    // 这里可以调用原生代码来安装APK
    // 由于Flutter的限制，需要平台特定的实现
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请手动安装下载的APK文件')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('下载中...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _progress),
          const SizedBox(height: 16),
          Text(_status),
        ],
      ),
      actions: [
        if (_isDownloading)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
      ],
    );
  }
}





