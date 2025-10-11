import 'package:flutter/material.dart';
import '../services/language_service.dart';
import 'package:provider/provider.dart';
import 'beifa_logo.dart';
import 'translate_icon.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度用于自适应
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.032, // 24px基于750px屏幕
        vertical: screenWidth * 0.016,    // 12px基于750px屏幕
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              BeifaLogo(
                width: screenWidth * 0.17866,   // 134px基于750px屏幕
                height: screenWidth * 0.03733, // 28px基于750px屏幕
              ),
            ],
          ),
          Consumer<LanguageService>(
            builder: (context, languageService, child) {
              return GestureDetector(
                onTap: () => _showLanguageDialog(context, languageService),
                child: Row(
                  children: [
                    TranslateIcon(
                      width: screenWidth * 0.034666,  // 26px基于750px屏幕
                      height: screenWidth * 0.034666, // 26px基于750px屏幕
                    ),
                    SizedBox(width: screenWidth * 0.010667), // 8px基于750px屏幕
                    Text(
                      languageService.getLanguageName(languageService.currentLocale),
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenWidth * 0.026667, // 20px基于750px屏幕
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择语言 / Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LanguageService.supportedLocales.map((locale) {
            return ListTile(
              title: Text(languageService.getLanguageName(locale)),
              onTap: () {
                languageService.changeLanguage(locale);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}




