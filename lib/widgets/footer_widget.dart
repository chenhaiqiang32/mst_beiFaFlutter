import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            '© 贝发集团股份有限公司 浙ICP备11016667号',
            style: TextStyle(
              fontSize: screenWidth * 0.024,
              color: Color(0xFF808080),
            ),
          ),
        ),
      ),
    );
  }
}





