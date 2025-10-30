import '../models/product.dart';

class DataServiceEn {
  static final DataServiceEn _instance = DataServiceEn._internal();
  factory DataServiceEn() => _instance;
  DataServiceEn._internal();

  // Featured banner texts
  String get featuredBannerTitle => 'BEIFA | App Downloads';
  String get featuredBannerSubtitle =>
      'Get official apps in one place — safe, fast, and easy';

  // Common button texts
  String get downloadButtonText => 'Download';
  String get detailsButtonText => 'App Details';

  // Footer text
  String get footerCopyright =>
      '© Beifa Group Co., Ltd. ICP No. 浙ICP备11016667号';

  // Product detail screen texts
  String get iosDownloadButtonText => 'Download for iOS';
  String get androidDownloadButtonText => 'Download for Android';
  String get iosDownloadSnackText => 'iOS download feature';

  String get statsLanguageLabel => 'Language';
  String get statsSizeLabel => 'Size';
  String get statsCurrentVersionLabel => 'Current Version';
  String get statsLatestLabel => 'Latest';
  String get statsMbUnit => 'MB';

  String get previewTitle => 'Preview';

  String get appIntroTitle => 'Introduction';
  String get expandText => 'More';
  String get collapseText => 'Less';
  String get textEllipsisChar => '…';

  String get infoTitle => 'Information';
  String get infoAppRatingLabel => 'Rating';
  String get infoLastUpdateLabel => 'Last Updated';
  String get infoDeveloperLabel => 'Developer';
  String get infoLanguageLabel => 'Languages';
  String get infoSupplierLabel => 'Supplier';

  String get accessibilityTitle => 'Accessibility';
  String get accessibilityDescription =>
      'The developer has not specified which accessibility features are supported.';

  // Download dialog texts
  String get downloadDialogTitle => 'Download';
  String get fileSizeLabel => 'File Size';
  String get recommendedAppsTitle => 'Recommended Apps';
  String get versionLabel => 'Version';
  String get downloadedProgressPrefix => 'Downloaded';
  String get downloadedProgressSuffix => '%';

  // Download service texts
  String get permissionStorageRequired =>
      'Storage permission is required to download apps';
  String get cannotGetStorageDir => 'Unable to get storage directory';
  String get downloadFailedPrefix => 'Download failed: ';
  String get openAppStoreFailedPrefix => 'Failed to open App Store: ';
  String get progressPreparing => 'Preparing download...';
  String get downloadCompletedTitle => 'Download Completed';
  String get downloadCompletedContent =>
      'The app has been downloaded. Do you want to install it now?';
  String get buttonInstallLater => 'Install Later';
  String get buttonInstallNow => 'Install Now';
  String get installSnackTip =>
      'Please install the downloaded APK file manually';
  String get downloadingTitle => 'Downloading...';
  String get buttonCancel => 'Cancel';
  String get errorDialogTitle => 'Error';
  String get buttonOk => 'OK';

  List<Product> getProducts() {
    return [
      Product(
        id: '1',
        name: 'Origins Translate',
        subtitle: 'BEIFA AITOP',
        subSubtitle: 'Social',
        description:
            'Provide convenient, efficient, and accurate cross-app translation to help users communicate seamlessly in multilingual scenarios and improve efficiency and quality.',
        logoUrl: 'images/logo/1.png',
        backgroundImageUrl: 'images/listBg/1.png',
        appInfo: AppInfo(
          version: '1.0.1',
          size: '129.8MB',
          supportedLanguages: ['RU', '+24 Languages'],
          developer: 'Yingying Du',
          appRating: '4+',
          lastUpdate: '2025/08/30',
          screenshots: [
            'images/productImages/origins/zh/1.png',
            'images/productImages/origins/zh/2.png',
            'images/productImages/origins/zh/3.png',
            'images/productImages/origins/zh/4.png',
          ],
          features: [
            'Social',
          ],
          informationLanguage: 'Urdu and 23 others',
          downloadInfo: DownloadInfo(
            androidUrl:'https://product-v3-file.url.mo.cn/apk-prod/ucenter/Teamhelper_Glass_ycl_2025-10-10_17-33-22_prod_release_v1.9.10.apk',
            iosUrl: 'https://apps.apple.com/cn/app/futora/id6751739046',
          ),
        ),
      ),
      Product(
        id: '2',
        name: 'Futora (Earbuds)',
        subtitle: 'Smartwatch 2‑in‑1',
        subSubtitle: 'AI Translation & Voice Assistant',
        description:
            'Futora is an AI-powered real-time voice assistant combined with audio hardware to deliver efficient cross-language communication. It integrates simultaneous interpretation, meeting minutes, real-time interactive translation, and AI Q&A to help you communicate without barriers in meetings, business, learning, and daily use.',
        logoUrl: 'images/logo/2.png',
        backgroundImageUrl: 'images/listBg/2.png',
        appInfo: AppInfo(
          version: '1.0.2',
          size: '42.4MB',
          supportedLanguages: ['RU', '+12 Languages'],
          developer: 'Yingying Du',
          appRating: '8+',
          lastUpdate: '2025/08/30',
          screenshots: [
            'images/productImages/futora/zh/1.png',
            'images/productImages/futora/zh/2.png',
            'images/productImages/futora/zh/3.png',
          ],
          features: [
            'Lifestyle',
          ],
          informationLanguage: 'Urdu and 23 others',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://product-v3-file.url.mo.cn/apk-prod/ucenter/Teamhelper_Glass_ycl_2025-10-10_17-33-22_prod_release_v1.9.10.apk',
            iosUrl: 'https://apps.apple.com/cn/app/futora/id6751739046',
          ),
        ),
      ),
      Product(
        id: '3',
        name: 'FitCloudPro (Watch)',
        subtitle: 'Smartwatch 2‑in‑1',
        subSubtitle: 'Health & Fitness',
        description:
            'Stay active and healthy with FitCloudPro. Track daily steps, calories, distance, and more. Monitor sleep, receive notifications, set reminders, and sync data with Apple Health via HealthKit.',
        logoUrl: 'images/logo/3.png',
        backgroundImageUrl: 'images/listBg/3.png',
        appInfo: AppInfo(
          version: '1.0.1',
          size: '313.9MB',
          supportedLanguages: ['RU', '+42 Languages'],
          developer: 'Xin Huang',
          appRating: '9+',
          lastUpdate: '2025/08/30',
          screenshots: [
            'images/productImages/fitCloudPro/zh/1.png',
            'images/productImages/fitCloudPro/zh/2.png',
            'images/productImages/fitCloudPro/zh/3.png',
          ],
          features: [
            'Health & Fitness'
          ],
          informationLanguage: 'Danish and 41 others',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://product-v3-file.url.mo.cn/apk-prod/ucenter/Teamhelper_Glass_ycl_2025-10-10_17-33-22_prod_release_v1.9.10.apk',
            iosUrl: 'https://apps.apple.com/cn/app/futora/id6751739046',
          ),
        ),
      ),
      Product(
        id: '4',
        name: 'DanaID',
        subtitle: 'Smartwatch GM2 Pro',
        subSubtitle: 'DanaID Agent',
        description:
            'DanaID is an intelligent assistant app that connects to smart wearables such as speakers, earbuds, and watches. Chat naturally with your devices, get knowledge, voice assistant, live transcription, translation across 140+ languages, and more for work and life.',
        logoUrl: 'images/logo/4.png',
        backgroundImageUrl: 'images/listBg/4.png',
        appInfo: AppInfo(
          version: '1.0.1',
          size: '66 MB',
          supportedLanguages: ['RU', '+18 Languages'],
          developer: '18 languages including Russian',
          appRating: '18+',
          lastUpdate: '2025/08/30',
          screenshots: [
            'images/productImages/danaID/zh/1.png',
            'images/productImages/danaID/zh/2.png',
            'images/productImages/danaID/zh/3.png',
            'images/productImages/danaID/zh/4.png',
          ],
          features: [
            'Productivity'
          ],
          informationLanguage: 'Chinese, English, Russian',
          downloadInfo: DownloadInfo(
            androidUrl:'https://product-v3-file.url.mo.cn/apk-prod/ucenter/Teamhelper_Glass_ycl_2025-10-10_17-33-22_prod_release_v1.9.10.apk',
            iosUrl: 'https://apps.apple.com/cn/app/futora/id6751739046',
          ),
        ),
      ),
      Product(
        id: '5',
        name: 'Nebulabuds',
        subtitle: 'AI Audio Glasses',
        subSubtitle: 'AI Noise-canceling Meeting Translator',
        description:
            'Nebula Buds AI Interpreting App supports up to 133 languages. Photo translation, AI voice wake, audio/video call translation, dual-ear mode, meeting minutes with speaker separation, AI chat, and AI image generation.',
        logoUrl: 'images/logo/5.png',
        backgroundImageUrl: 'images/listBg/5.png',
        appInfo: AppInfo(
          version: '1.0.1',
          size: '140.2MB',
          supportedLanguages: ['RU', '+12 Languages'],
          developer: 'Shanghai Palm Zen Wireless Technology Co., Ltd.',
          appRating: '18+',
          lastUpdate: '2025/08/30',
          screenshots: [
            'images/productImages/nebulabuds/zh/1.png',
            'images/productImages/nebulabuds/zh/2.png',
            'images/productImages/nebulabuds/zh/3.png',
            'images/productImages/nebulabuds/zh/4.png',
          ],
          features: [
            'Tools'
          ],
          informationLanguage: 'Danish and 26 others',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://product-v3-file.url.mo.cn/apk-prod/ucenter/Teamhelper_Glass_ycl_2025-10-10_17-33-22_prod_release_v1.9.10.apk',
            iosUrl: 'https://apps.apple.com/cn/app/futora/id6751739046',
          ),
        ),
      )
    ];
  }

  List<Product> getRecommendedApps() {
    return [
      Product(
        id: '1',
        name: 'Qidian Reading',
        subtitle: 'v7.9.426',
        subSubtitle: 'Reading',
        description: 'Features · Privacy · Permissions',
        logoUrl: 'assets/images/qidian_logo.png',
        appInfo: AppInfo(
          version: '7.9.426',
          size: '45.2 MB',
          supportedLanguages: ['CN'],
          developer: 'Shanghai Xuanting Entertainment Information Technology Co., Ltd.',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: 'Chinese',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/qidian.apk',
            iosUrl: 'https://apps.apple.com/app/qidian',
            androidFileName: 'qidian_7.9.426.apk',
          ),
        ),
      ),
      Product(
        id: '2',
        name: 'Tomato Audio',
        subtitle: 'v6.0.8.32',
        subSubtitle: 'Audio',
        description: 'Features · Privacy · Permissions',
        logoUrl: 'assets/images/tomato_logo.png',
        appInfo: AppInfo(
          version: '6.0.8.32',
          size: '38.7 MB',
          supportedLanguages: ['CN'],
          developer: 'Beijing Zhendin Technology Co., Ltd.',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: 'Chinese',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/tomato.apk',
            iosUrl: 'https://apps.apple.com/app/tomato',
            androidFileName: 'tomato_6.0.8.32.apk',
          ),
        ),
      ),
      Product(
        id: '3',
        name: 'Xigua Video',
        subtitle: 'v9.8.2',
        subSubtitle: 'Video',
        description: 'Features · Privacy · Permissions',
        logoUrl: 'assets/images/xigua_logo.png',
        appInfo: AppInfo(
          version: '9.8.2',
          size: '52.1 MB',
          supportedLanguages: ['CN'],
          developer: 'Beijing Douyin Information Service Co., Ltd.',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: 'Chinese',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/xigua.apk',
            iosUrl: 'https://apps.apple.com/app/xigua',
            androidFileName: 'xigua_9.8.2.apk',
          ),
        ),
      ),
      Product(
        id: '4',
        name: 'Xigua Video',
        subtitle: 'v9.8.2',
        subSubtitle: 'Video',
        description: 'Features · Privacy · Permissions',
        logoUrl: 'assets/images/xigua_logo.png',
        appInfo: AppInfo(
          version: '9.8.2',
          size: '52.1 MB',
          supportedLanguages: ['CN'],
          developer: 'Beijing Douyin Information Service Co., Ltd.',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: 'Chinese',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/xigua.apk',
            iosUrl: 'https://apps.apple.com/app/xigua',
            androidFileName: 'xigua_9.8.2.apk',
          ),
        ),
      ),
      Product(
        id: '5',
        name: 'Xigua Video',
        subtitle: 'v9.8.2',
        subSubtitle: 'Video',
        description: 'Features · Privacy · Permissions',
        logoUrl: 'assets/images/xigua_logo.png',
        appInfo: AppInfo(
          version: '9.8.2',
          size: '52.1 MB',
          supportedLanguages: ['CN'],
          developer: 'Beijing Douyin Information Service Co., Ltd.',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: 'Chinese',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/xigua.apk',
            iosUrl: 'https://apps.apple.com/app/xigua',
            androidFileName: 'xigua_9.8.2.apk',
          ),
        ),
      ),
    ];
  }
}


