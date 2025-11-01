import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../services/data_service.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  final DataService _dataService = DataService();

  Future<void> downloadAndroidApp(String url, String fileName, BuildContext context) async {
    try {
      // For Android 10+, use app-specific directory which doesn't require storage permission
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        _showErrorDialog(context, _dataService.cannotGetStorageDir);
        return;
      }

      final filePath = '${directory.path}/$fileName';
      
      // 显示下载进度
      _showDownloadProgress(context, url, filePath);
      
    } catch (e) {
      _showErrorDialog(context, '${_dataService.downloadFailedPrefix}$e');
    }
  }

  Future<void> openIOSAppStore(String url) async {
    try {
      print('[DownloadService] Attempt to open iOS App Store url=$url');
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        print('[DownloadService] Launch success');
      }
    } catch (e) {
      print('${DataService().openAppStoreFailedPrefix}$e');
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
        title: Text(DataService().errorDialogTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(DataService().buttonOk),
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
  String _status = DataService().progressPreparing;
  final DataService _dataService = DataService();

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
              _status = '${_dataService.downloadedProgressPrefix}${(_progress * 100).toInt()}${_dataService.downloadedProgressSuffix}';
            });
          }
        },
      );

      setState(() {
        _isDownloading = false;
        _status = _dataService.downloadCompletedTitle;
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
        title: Text(_dataService.downloadCompletedTitle),
        content: Text(_dataService.downloadCompletedContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_dataService.buttonInstallLater),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _installApp();
            },
            child: Text(_dataService.buttonInstallNow),
          ),
        ],
      ),
    );
  }

  void _installApp() {
    // 这里可以调用原生代码来安装APK
    // 由于Flutter的限制，需要平台特定的实现
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_dataService.installSnackTip)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_dataService.downloadingTitle),
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
            child: Text(_dataService.buttonCancel),
          ),
      ],
    );
  }
}





