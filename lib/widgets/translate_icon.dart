import 'package:flutter/material.dart';

class TranslateIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? fallbackColor;

  const TranslateIcon({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/translate_icon.png',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // 如果图片加载失败，显示备用图标
        return Container(
          width: width ?? 20,
          height: height ?? 20,
          decoration: BoxDecoration(
            color: fallbackColor ?? Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.translate,
            size: (width ?? 20) * 0.7,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
