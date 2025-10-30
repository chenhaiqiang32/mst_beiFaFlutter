import '../models/product.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Product> getProducts() {
    return [
      Product(
        id: '1',
        name: 'Origins Translate', // 列表页和详情页logo的名称
        subtitle: '贝发 AITOP', // 列表页的副标题
        subSubtitle: '社交', // 详情页的副标题
        description: '提供便捷、高效、精准的跨应用翻译服务，助力用户在多语言环境中实现无障碍沟通，提升沟通效率与质量。', // 列表页详情页描述内容
        logoUrl: 'images/logo/1.png', // 列表页详情页的logo图片
        backgroundImageUrl: 'images/listBg/1.png', // 列表页的背景图片
        appInfo: AppInfo(
          version: '1.0.1', // 商品详情版本号
          size: '129.8MB', // 商品详情大小
          supportedLanguages: ['RU', '+24种语言'], // 商品详情语言
          developer: '莹莹 杜', // 商品详情开发者
          appRating: '4+', // 商品详情评分
          lastUpdate: '2025/08/30', // 商品详情更新时间
          screenshots: [  // 商品详情的轮播图片
            'images/productImages/origins/zh/1.png',
            'images/productImages/origins/zh/2.png',
            'images/productImages/origins/zh/3.png',
            'images/productImages/origins/zh/4.png',
          ],
          features: [ // 商品详情标签
            '社交',
          ],
          informationLanguage: '乌尔都文和另外23种', // 信息语言
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/novxx.apk',
            iosUrl: 'https://apps.apple.com/app/novxx',
          ),
        ),
      ),
      Product(
        id: '2',
        name: 'Futora（耳机）',
        subtitle: '智能手表二合一',
        subSubtitle: 'AI翻译与语音助手', // 详情页的副标题
        description: 'Futora 是一款由 AI驱动的未来语音实时助手，结合智能算法与音频硬件，为用户提供高效的跨语言交流体验。它集成了同声传译、会议纪要、实时互动翻译、AI智能问答等功能，帮助用户突破语言障碍，实现无缝沟通。无论是在国际会议、跨境商务、学习还是日常交流中，Futora都能即时识别语音、智能翻译并生成记录，让沟通更高效、更智能。',
        logoUrl: 'images/logo/2.png',
        backgroundImageUrl: 'images/listBg/2.png',
        appInfo: AppInfo(
          version: '1.0.2',
          size: '42.4MB',
          supportedLanguages: ['RU', '+12种语言'],
          developer: '莹莹 杜',
          appRating: '8+',
          lastUpdate: '2025/08/30',
          screenshots: [
            'images/productImages/futora/zh/1.png',
            'images/productImages/futora/zh/2.png',
            'images/productImages/futora/zh/3.png',
          ],
          features: [
            '生活',
          ],
          informationLanguage: '乌尔都文和另外23种',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/origins.apk',
            iosUrl: 'https://apps.apple.com/app/origins',
          ),
        ),
      ),
      Product(
        id: '3',
        name: 'FitCloudPro（手表）',
        subtitle: '智能手表二合一',
        subSubtitle: '健康健美', // 详情页的副标题
        description: '文案生活是运动，运动更健康，你今天运动吗?从现在开始，按照 FitCloudPro进行更改!无论您是关注运动数据还是睡眠或身体健康，智能手表FitCloudPro始终如此给你想要的:【标准运动数据】FitCloudPro准确地为您提供每日运动步数，卡路里，距离和其他数据。【睡眠监测器】通过保持每日深度睡眠，轻度睡眠和清醒状态记录，您可以更好地了解您的睡眠状况并合理安排睡眠时间。【通知提醒】使用智能手表，你不必担心手机不在一边不能接收短信电话，微信，WhatSapp，Line和许多其他应用新闻FitCloudPro打开开关，手表就能及时通知你了久坐提醒害怕长时间坐着会影响健康吗?在FitCloudPro中为智能手表设置提醒时间，手表会震惊提醒你起床锻炼!喝水提醒及时补充水分更有益于您的健康，FitCloudPro智能手表更适合你的服务!智能闹钟)为 FitCloudPro手表设置智能闹钟，唤醒以提醒您起床或工作，不再打扰周围的人!防丢提醒害怕手机丢失?如果手机保持连接状态，请查找手机并观察连接状态范围，智能手表会振动提醒，手机会响铃!其他数据信息?快速拿起手表进行测量!加入 FitCloudPro，与很多关心自己健康的人见面吧!FitCloudPro 通过 HealthKit 将你的 FitCloudPro 活动导入健康应用，读取运动数据。',
        logoUrl: 'images/logo/3.png',
        backgroundImageUrl: 'images/listBg/3.png',
        appInfo: AppInfo(
          version: '1.0.1',
          size: '313.9MB',
          supportedLanguages: ['RU', '+42种语言'],
          developer: '欣 黄',
          appRating: '9+',
          lastUpdate: '2025/08/30',
          screenshots: [
            'images/productImages/fitCloudPro/zh/1.png',
            'images/productImages/fitCloudPro/zh/2.png',
            'images/productImages/fitCloudPro/zh/3.png',
          ],
          features: [
            '健康健美'
          ],
          informationLanguage: '丹麦语和另外41种',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/gloryfit.apk',
            iosUrl: 'https://apps.apple.com/app/gloryfit',
          ),
        ),
      ),
      Product(
        id: '4',
        name: 'DanaID',
        subtitle: '智能手表 GM2 Pro',
        subSubtitle: 'DanaID智能体', // 详情页的副标题
        description: 'DanalD APP是由大拿智能打造的一款智能助手APP，能够连接多款智能穿戴设备，包含但不仅限于:智能音箱、蓝牙音箱、耳机、手表等。用户可以通过APP与设备相连，实现以自然语言方便流畅的与设备、手机对话，获得丰富的A体验。【设备管理】智能穿戴设备与 Dana连接，一秒开启AI体验，轻松易用。【语音助手】它不只是你的娱乐伙伴为你讲述精彩故事、播放动人音乐;更是你的生活秘书，助你查询知识百科、了解天气情况、掌握黄历信息、知悉实时资讯，一问便知，宛如贴心助理，为你强力赋能。【知识问答】深入探索无尽的知识世界，你仅需提出心中疑问，Dan:便会耐心地为你解答，直至清楚为止。【内容创作】从写作文案、活动策划、朋友圈文案、到高情商回复，Dana都会成为你得力创作助手。【闲聊互动】超长上下文连续对话能力，可以让你尽情的与 AI自由交流，享受互动乐趣。【AI翻译)支持140+种语言互译，集成实时翻译功能，打破语言壁垒，助力全球用户无障碍沟通。【实时语音转写】支持140+语言现场语音记录，实时进行文字转写，同时A智能总结关键信息，有效节省时间和精力，使工作高效快捷。',
        logoUrl: 'images/logo/4.png',
        backgroundImageUrl: 'images/listBg/4.png',
        appInfo: AppInfo(
          version: '1.0.1',
          size: '66 MB',
          supportedLanguages: ['RU', '+ 18种语言'],
          developer: '俄文和另外17种',
          appRating: '18+',
          lastUpdate: '2025/08/30',
          screenshots: [
            'images/productImages/danaID/zh/1.png',
            'images/productImages/danaID/zh/2.png',
            'images/productImages/danaID/zh/3.png',
            'images/productImages/danaID/zh/4.png',
          ],
          features: [
            '效率'
          ],
          informationLanguage: '中文、英语、俄语',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/mosstalk.apk',
            iosUrl: 'https://apps.apple.com/app/mosstalk',
          ),
        ),
      ),
      Product(
        id: '5',
        name: 'Nebulabuds',
        subtitle: 'AI音频眼镜',
        subSubtitle: 'AI降噪会议音视频翻译', // 详情页的副标题
        description: 'Nebula Buds AI同传APP，最多可翻译133种语言 拍照翻译:路牌、菜单、商品标签，一拍即译，字体排版 1:1 还原。 .DeepSeek R1:最新AI大模型，实时联网，深度思考过程看得到。 ·AI语音唤醒:喊一声“Hey Nebula”，查询天气新闻等实时资讯。 音视频通话翻译:边视频，边翻译。对方无需下载APP双耳模式:一人一只耳机，同时开口，随时插话，摆脱回合式聊天。 会议记录:区分说话人，快速总结会议内容。 -AI智能对话:逼真语音，随问随答，为你的生活工作出谋划策。 同声传译:133种语言，即时翻译，你的耳边翻译官AI绘画:绘画0门槛。只需文字和参考图，就能创作，',
        logoUrl: 'images/logo/5.png',
        backgroundImageUrl: 'images/listBg/5.png',
        appInfo: AppInfo(
          version: '1.0.1',
          size: '140.2MB',
          supportedLanguages: ['RU', '+ 12种语言'],
          developer: '上海掌禅无线科技有限公司',
          appRating: '18+',
          lastUpdate: '2025/08/30',
          screenshots: [
            'images/productImages/nebulabuds/zh/1.png',
            'images/productImages/nebulabuds/zh/2.png',
            'images/productImages/nebulabuds/zh/3.png',
            'images/productImages/nebulabuds/zh/4.png',
          ],
          features: [
            '工具'
          ],
          informationLanguage: '丹麦语和另外26种',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/smartpen.apk',
            iosUrl: 'https://apps.apple.com/app/smartpen',
          ),
        ),
      )
    ];
  }

  List<Product> getRecommendedApps() {
    return [
      Product(
        id: '1',
        name: '起点读书',
        subtitle: '版本7.9.426',
        subSubtitle: '阅读应用',
        description: '功能 隐私 权限',
        logoUrl: 'assets/images/qidian_logo.png',
        appInfo: AppInfo(
          version: '7.9.426',
          size: '45.2 MB',
          supportedLanguages: ['CN'],
          developer: '上海玄霆娱乐信息科技有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: '中文',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/qidian.apk',
            iosUrl: 'https://apps.apple.com/app/qidian',
            androidFileName: 'qidian_7.9.426.apk',
          ),
        ),
      ),
      Product(
        id: '2',
        name: '番茄畅听',
        subtitle: '版本6.0.8.32',
        subSubtitle: '音频应用',
        description: '功能 隐私 权限',
        logoUrl: 'assets/images/tomato_logo.png',
        appInfo: AppInfo(
          version: '6.0.8.32',
          size: '38.7 MB',
          supportedLanguages: ['CN'],
          developer: '北京臻鼎科技有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: '中文',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/tomato.apk',
            iosUrl: 'https://apps.apple.com/app/tomato',
            androidFileName: 'tomato_6.0.8.32.apk',
          ),
        ),
      ),
      Product(
        id: '3',
        name: '西瓜视频',
        subtitle: '版本9.8.2',
        subSubtitle: '视频应用',
        description: '功能 隐私 权限',
        logoUrl: 'assets/images/xigua_logo.png',
        appInfo: AppInfo(
          version: '9.8.2',
          size: '52.1 MB',
          supportedLanguages: ['CN'],
          developer: '北京抖音信息服务有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: '中文',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/xigua.apk',
            iosUrl: 'https://apps.apple.com/app/xigua',
            androidFileName: 'xigua_9.8.2.apk',
          ),
        ),
      ),
      Product(
        id: '4',
        name: '西瓜视频',
        subtitle: '版本9.8.2',
        subSubtitle: '视频应用',
        description: '功能 隐私 权限',
        logoUrl: 'assets/images/xigua_logo.png',
        appInfo: AppInfo(
          version: '9.8.2',
          size: '52.1 MB',
          supportedLanguages: ['CN'],
          developer: '北京抖音信息服务有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: '中文',
          downloadInfo: DownloadInfo(
            androidUrl: 'https://example.com/xigua.apk',
            iosUrl: 'https://apps.apple.com/app/xigua',
            androidFileName: 'xigua_9.8.2.apk',
          ),
        ),
      ),
      Product(
        id: '5',
        name: '西瓜视频',
        subtitle: '版本9.8.2',
        subSubtitle: '视频应用',
        description: '功能 隐私 权限',
        logoUrl: 'assets/images/xigua_logo.png',
        appInfo: AppInfo(
          version: '9.8.2',
          size: '52.1 MB',
          supportedLanguages: ['CN'],
          developer: '北京抖音信息服务有限公司',
          appRating: '4+',
          lastUpdate: '2025/01/01',
          screenshots: [],
          features: [],
          informationLanguage: '中文',
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





