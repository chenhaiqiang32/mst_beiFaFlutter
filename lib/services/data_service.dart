import '../models/product.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Product> getProducts() {
    return [
      Product(
        id: '1',
        name: 'NOVXX',
        subtitle: 'AI智能眼镜',
        description: 'NOVXX通过链接AI拍照眼镜,实现同步照片、视频、录音、翻译和语音控制等服务。',
        logoUrl: 'assets/images/novxx_logo.png',
        productImages: [
          'assets/images/novxx_glasses1.png',
          'assets/images/novxx_glasses2.png',
        ],
        category: 'AI眼镜',
        isFeatured: true,
        appInfo: AppInfo(
          appName: 'NOVXX',
          version: '1.0.1',
          size: '78.6 MB',
          supportedLanguages: ['RU', '+12种语言'],
          developer: '深圳国瑞发展教育有限公司',
          appRating: '8+',
          lastUpdate: '2025/08/30',
          newFeatures: '问题修复和体验优化。',
          officialWebsite: 'https://www.szgredu.com/',
          screenshots: [
            'assets/images/novxx_screenshot1.png',
            'assets/images/novxx_screenshot2.png',
            'assets/images/novxx_screenshot3.png',
            'assets/images/novxx_screenshot4.png',
          ],
          features: [
            '影院级音频体验:旗舰芯片驱动·专业级音质处理',
            'AI智能交互系统:ChatGPT4.0本地化・响应提速40%',
            '健康护眼科技:2000个/cm³负离子・缓解眼疲劳',
            '高效商务会议:100+语言实时互译・覆盖专业术语',
            '智能旅行助手:38g超轻设计・佩戴无负担;7小时强劲续航',
          ],
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/novxx.apk',
            iosUrl: 'https://apps.apple.com/app/novxx',
            androidFileName: 'nova_ai_4600...7.apk',
            androidFileSize: '114.68MB',
          ),
        ),
      ),
      Product(
        id: '2',
        name: 'ORIGINS',
        subtitle: '贝发 AITOP',
        description: '贝发AITOP 系列专属APP,支持智能设备管理和AI功能。',
        logoUrl: 'assets/images/origins_logo.png',
        productImages: [
          'assets/images/origins_device1.png',
          'assets/images/origins_device2.png',
          'assets/images/origins_device3.png',
        ],
        category: 'AI设备',
        appInfo: AppInfo(
          appName: 'ORIGINS',
          version: '2.1.0',
          size: '45.2 MB',
          supportedLanguages: ['CN', 'EN'],
          developer: '贝发集团股份有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/15',
          newFeatures: '新增AI语音助手功能。',
          officialWebsite: 'https://www.beifa.com',
          screenshots: [
            'assets/images/origins_screenshot1.png',
            'assets/images/origins_screenshot2.png',
          ],
          features: [
            '智能设备管理',
            'AI语音助手',
            '远程控制功能',
            '数据同步',
          ],
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/origins.apk',
            iosUrl: 'https://apps.apple.com/app/origins',
            androidFileName: 'origins_ai_2.1.0.apk',
            androidFileSize: '45.2MB',
          ),
        ),
      ),
      Product(
        id: '3',
        name: 'GLORYFIT',
        subtitle: '智能手环',
        description: '智能手环 T54 配套APP,覆盖心率监测、运动追踪等功能。',
        logoUrl: 'assets/images/gloryfit_logo.png',
        productImages: [
          'assets/images/gloryfit_band1.png',
          'assets/images/gloryfit_band2.png',
          'assets/images/gloryfit_band3.png',
          'assets/images/gloryfit_band4.png',
        ],
        category: '智能穿戴',
        appInfo: AppInfo(
          appName: 'GLORYFIT',
          version: '3.2.1',
          size: '32.8 MB',
          supportedLanguages: ['CN', 'EN', 'JP'],
          developer: '贝发集团股份有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/10',
          newFeatures: '优化运动算法，提升数据准确性。',
          officialWebsite: 'https://www.beifa.com',
          screenshots: [
            'assets/images/gloryfit_screenshot1.png',
            'assets/images/gloryfit_screenshot2.png',
          ],
          features: [
            '心率监测',
            '运动追踪',
            '睡眠分析',
            '健康报告',
          ],
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/gloryfit.apk',
            iosUrl: 'https://apps.apple.com/app/gloryfit',
            androidFileName: 'gloryfit_t54_3.2.1.apk',
            androidFileSize: '32.8MB',
          ),
        ),
      ),
      Product(
        id: '4',
        name: 'MOSSTALK',
        subtitle: 'MOSSTALK AI大模型翻译机',
        description: 'AI 大模型翻译机配套APP,含100+语言实时翻译功能。',
        logoUrl: 'assets/images/mosstalk_logo.png',
        productImages: [
          'assets/images/mosstalk_device.png',
        ],
        category: 'AI翻译',
        appInfo: AppInfo(
          appName: 'MOSSTALK',
          version: '1.5.3',
          size: '67.4 MB',
          supportedLanguages: ['CN', 'EN', 'RU', 'JP', 'KR'],
          developer: '贝发集团股份有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/05',
          newFeatures: '新增离线翻译功能。',
          officialWebsite: 'https://www.beifa.com',
          screenshots: [
            'assets/images/mosstalk_screenshot1.png',
            'assets/images/mosstalk_screenshot2.png',
          ],
          features: [
            '100+语言实时翻译',
            '离线翻译',
            '语音识别',
            '拍照翻译',
          ],
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/mosstalk.apk',
            iosUrl: 'https://apps.apple.com/app/mosstalk',
            androidFileName: 'mosstalk_ai_1.5.3.apk',
            androidFileSize: '67.4MB',
          ),
        ),
      ),
    ];
  }

  List<Product> getRecommendedApps() {
    return [
      Product(
        id: 'rec1',
        name: '起点读书',
        subtitle: '版本7.9.426',
        description: '功能 隐私 权限',
        logoUrl: 'assets/images/qidian_logo.png',
        productImages: [],
        category: '阅读',
        appInfo: AppInfo(
          appName: '起点读书',
          version: '7.9.426',
          size: '45.2 MB',
          supportedLanguages: ['CN'],
          developer: '上海玄霆娱乐信息科技有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          newFeatures: '优化阅读体验',
          officialWebsite: 'https://www.qidian.com',
          screenshots: [],
          features: [],
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/qidian.apk',
            iosUrl: 'https://apps.apple.com/app/qidian',
            androidFileName: 'qidian_7.9.426.apk',
            androidFileSize: '45.2MB',
          ),
        ),
      ),
      Product(
        id: 'rec2',
        name: '番茄畅听',
        subtitle: '版本6.0.8.32',
        description: '功能 隐私 权限',
        logoUrl: 'assets/images/tomato_logo.png',
        productImages: [],
        category: '音频',
        appInfo: AppInfo(
          appName: '番茄畅听',
          version: '6.0.8.32',
          size: '38.7 MB',
          supportedLanguages: ['CN'],
          developer: '北京臻鼎科技有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          newFeatures: '新增有声书功能',
          officialWebsite: 'https://www.tomato.com',
          screenshots: [],
          features: [],
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/tomato.apk',
            iosUrl: 'https://apps.apple.com/app/tomato',
            androidFileName: 'tomato_6.0.8.32.apk',
            androidFileSize: '38.7MB',
          ),
        ),
      ),
      Product(
        id: 'rec3',
        name: '西瓜视频',
        subtitle: '版本9.8.2',
        description: '功能 隐私 权限',
        logoUrl: 'assets/images/xigua_logo.png',
        productImages: [],
        category: '视频',
        appInfo: AppInfo(
          appName: '西瓜视频',
          version: '9.8.2',
          size: '52.1 MB',
          supportedLanguages: ['CN'],
          developer: '北京抖音信息服务有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          newFeatures: '优化视频播放',
          officialWebsite: 'https://www.xigua.com',
          screenshots: [],
          features: [],
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/xigua.apk',
            iosUrl: 'https://apps.apple.com/app/xigua',
            androidFileName: 'xigua_9.8.2.apk',
            androidFileSize: '52.1MB',
          ),
        ),
      ),
    ];
  }
}





