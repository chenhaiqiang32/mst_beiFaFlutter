class Product {
  final String id;
  final String name;
  final String subtitle;
  final String subSubtitle;
  final String description;
  final String logoUrl;
  final AppInfo appInfo;
  final String? backgroundImageUrl;

  Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.subSubtitle,
    required this.description,
    required this.logoUrl,
    required this.appInfo,
    this.backgroundImageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      subSubtitle: json['subSubtitle'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      appInfo: AppInfo.fromJson(json['appInfo'] ?? {}),
      backgroundImageUrl: json['backgroundImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'subSubtitle': subSubtitle,
      'description': description,
      'logoUrl': logoUrl,
      'appInfo': appInfo.toJson(),
      'backgroundImageUrl': backgroundImageUrl,
    };
  }
}

class AppInfo {
  final String version;
  final String size;
  final List<String> supportedLanguages;
  final String developer;
  final String appRating;
  final String lastUpdate;
  final List<String> screenshots;
  final List<String> features;
  final DownloadInfo downloadInfo;
  final String informationLanguage; // 信息语言字段

  AppInfo({
    required this.version,
    required this.size,
    required this.supportedLanguages,
    required this.developer,
    required this.appRating,
    required this.lastUpdate,
    required this.screenshots,
    required this.features,
    required this.downloadInfo,
    required this.informationLanguage,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      version: json['version'] ?? '',
      size: json['size'] ?? '',
      supportedLanguages: List<String>.from(json['supportedLanguages'] ?? []),
      developer: json['developer'] ?? '',
      appRating: json['appRating'] ?? '',
      lastUpdate: json['lastUpdate'] ?? '',
      screenshots: List<String>.from(json['screenshots'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      downloadInfo: DownloadInfo.fromJson(json['downloadInfo'] ?? {}),
      informationLanguage: json['informationLanguage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'size': size,
      'supportedLanguages': supportedLanguages,
      'developer': developer,
      'appRating': appRating,
      'lastUpdate': lastUpdate,
      'screenshots': screenshots,
      'features': features,
      'downloadInfo': downloadInfo.toJson(),
      'informationLanguage': informationLanguage,
    };
  }
}

class DownloadInfo {
  final String androidUrl;
  final String iosUrl;
  final String? androidFileName;

  DownloadInfo({
    required this.androidUrl,
    required this.iosUrl,
    this.androidFileName,
  });

  factory DownloadInfo.fromJson(Map<String, dynamic> json) {
    return DownloadInfo(
      androidUrl: json['androidUrl'] ?? '',
      iosUrl: json['iosUrl'] ?? '',
      androidFileName: json['androidFileName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'androidUrl': androidUrl,
      'iosUrl': iosUrl,
      'androidFileName': androidFileName,
    };
  }
}





