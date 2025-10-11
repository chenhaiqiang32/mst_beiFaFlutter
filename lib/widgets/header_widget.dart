import 'package:flutter/material.dart';
import '../services/language_service.dart';
import 'package:provider/provider.dart';
import 'beifa_logo.dart';
import 'translate_icon.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const BeifaLogo(
                width: 120,
                height: 24,
              ),
            ],
          ),
          Consumer<LanguageService>(
            builder: (context, languageService, child) {
              return GestureDetector(
                onTap: () => _showLanguageDialog(context, languageService),
                child: Row(
                  children: [
                    const TranslateIcon(
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      languageService.getLanguageName(languageService.currentLocale),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
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




