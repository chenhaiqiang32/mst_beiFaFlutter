class Product {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final String logoUrl;
  final List<String> productImages;
  final String category;
  final AppInfo appInfo;
  final bool isFeatured;

  Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.logoUrl,
    required this.productImages,
    required this.category,
    required this.appInfo,
    this.isFeatured = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      productImages: List<String>.from(json['productImages'] ?? []),
      category: json['category'] ?? '',
      appInfo: AppInfo.fromJson(json['appInfo'] ?? {}),
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'description': description,
      'logoUrl': logoUrl,
      'productImages': productImages,
      'category': category,
      'appInfo': appInfo.toJson(),
      'isFeatured': isFeatured,
    };
  }
}

class AppInfo {
  final String appName;
  final String version;
  final String size;
  final List<String> supportedLanguages;
  final String developer;
  final String appRating;
  final String lastUpdate;
  final String newFeatures;
  final String officialWebsite;
  final List<String> screenshots;
  final List<String> features;
  final DownloadInfo downloadInfo;

  AppInfo({
    required this.appName,
    required this.version,
    required this.size,
    required this.supportedLanguages,
    required this.developer,
    required this.appRating,
    required this.lastUpdate,
    required this.newFeatures,
    required this.officialWebsite,
    required this.screenshots,
    required this.features,
    required this.downloadInfo,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      appName: json['appName'] ?? '',
      version: json['version'] ?? '',
      size: json['size'] ?? '',
      supportedLanguages: List<String>.from(json['supportedLanguages'] ?? []),
      developer: json['developer'] ?? '',
      appRating: json['appRating'] ?? '',
      lastUpdate: json['lastUpdate'] ?? '',
      newFeatures: json['newFeatures'] ?? '',
      officialWebsite: json['officialWebsite'] ?? '',
      screenshots: List<String>.from(json['screenshots'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      downloadInfo: DownloadInfo.fromJson(json['downloadInfo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'version': version,
      'size': size,
      'supportedLanguages': supportedLanguages,
      'developer': developer,
      'appRating': appRating,
      'lastUpdate': lastUpdate,
      'newFeatures': newFeatures,
      'officialWebsite': officialWebsite,
      'screenshots': screenshots,
      'features': features,
      'downloadInfo': downloadInfo.toJson(),
    };
  }
}

class DownloadInfo {
  final String androidUrl;
  final String iosUrl;
  final String androidFileName;
  final String androidFileSize;

  DownloadInfo({
    required this.androidUrl,
    required this.iosUrl,
    required this.androidFileName,
    required this.androidFileSize,
  });

  factory DownloadInfo.fromJson(Map<String, dynamic> json) {
    return DownloadInfo(
      androidUrl: json['androidUrl'] ?? '',
      iosUrl: json['iosUrl'] ?? '',
      androidFileName: json['androidFileName'] ?? '',
      androidFileSize: json['androidFileSize'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'androidUrl': androidUrl,
      'iosUrl': iosUrl,
      'androidFileName': androidFileName,
      'androidFileSize': androidFileSize,
    };
  }
}





