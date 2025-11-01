import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'language_service.dart';
import 'data_service.dart';
import 'data_service_en.dart';

/// Returns localized data service (Chinese or English) depending on current locale.
class LocalizedData {
  static dynamic of(BuildContext context) {
    // watch to rebuild callers when language changes
    final locale = context.watch<LanguageService>().currentLocale;
    if (locale.languageCode == 'en') {
      return DataServiceEn();
    }
    return DataService();
  }
  
  /// Returns localized data service without watching for changes
  static dynamic ofWithoutListen(BuildContext context) {
    // read without watching to avoid rebuilding in callbacks
    final locale = Provider.of<LanguageService>(context, listen: false).currentLocale;
    if (locale.languageCode == 'en') {
      return DataServiceEn();
    }
    return DataService();
  }
}


