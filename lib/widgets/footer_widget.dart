import 'package:flutter/material.dart';
import '../services/data_service.dart';

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
            DataService().footerCopyright,
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





