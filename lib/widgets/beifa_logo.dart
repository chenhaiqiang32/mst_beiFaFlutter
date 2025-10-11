import 'package:flutter/material.dart';

class BeifaLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;

  const BeifaLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/beifa_logo.png',
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        // 如果图片加载失败，显示备用logo
        return Container(
          width: width ?? 120,
          height: height ?? 24,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              'BEIFA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

