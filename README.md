# 贝发集团智能产品APP导航平台

## 项目简介

贝发集团智能产品APP导航平台是一个基于Flutter开发的多平台移动应用，为用户提供贝发集团旗下智能产品的统一展示和下载平台。该应用支持iOS、Android和macOS平台，提供中英文双语支持。

## 主要功能

### 1. 产品展示
- **产品列表**：展示贝发集团旗下5款智能产品应用
- **产品详情**：包含产品截图、应用信息、版本信息、开发者信息等
- **特色横幅**：首页展示推荐产品横幅
- **产品卡片**：美观的产品卡片展示，支持快速下载和查看详情

### 2. 多语言支持
- 支持中文（简体）和英文（美式）
- 语言切换功能，用户可随时切换界面语言
- 语言偏好自动保存，下次启动时自动恢复

### 3. 应用下载
- **Android平台**：支持APK文件下载，显示下载进度，支持安装引导
- **iOS平台**：跳转到App Store进行应用下载
- **下载管理**：自动检测已下载文件，支持直接安装

### 4. 其他功能
- 响应式设计，适配不同屏幕尺寸
- 图片缓存优化，提升加载速度
- 权限管理，确保下载功能正常使用
- 底部版权信息展示

## 支持的产品

1. **Origins Translate（贝发 AITOP）**
   - 跨应用翻译服务
   - 支持多语言环境下的无障碍沟通

2. **Futora（智能耳机）**
   - AI驱动的语音实时助手
   - 同声传译、会议纪要、实时互动翻译

3. **FitCloudPro（智能手表）**
   - 健康健美应用
   - 运动数据监测、睡眠监测、通知提醒

4. **DanaID（智能手表 GM2 Pro）**
   - 智能助手应用
   - 设备管理、语音助手、知识问答、内容创作

5. **Nebulabuds（AI音频眼镜）**
   - AI降噪会议音视频翻译
   - 支持133种语言翻译，拍照翻译功能

## 技术栈

### 核心框架
- **Flutter**：跨平台UI框架
- **Dart**：编程语言（SDK >= 3.0.0）

### 主要依赖
- `provider`：状态管理
- `dio`：HTTP网络请求
- `http`：HTTP客户端
- `cached_network_image`：网络图片缓存
- `url_launcher`：URL和应用启动
- `shared_preferences`：本地数据存储
- `permission_handler`：权限管理
- `path_provider`：文件路径获取
- `flutter_localizations`：国际化支持
- `intl`：国际化工具

### 平台支持
- **iOS**：iOS 13.0及以上版本
- **Android**：支持最新Android版本
- **macOS**：支持macOS平台

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── models/                      # 数据模型
│   └── product.dart            # 产品数据模型
├── screens/                     # 页面
│   ├── home_screen.dart        # 首页
│   └── product_detail_screen.dart  # 产品详情页
├── services/                    # 服务层
│   ├── data_service.dart       # 数据服务（中文）
│   ├── data_service_en.dart    # 数据服务（英文）
│   ├── download_service.dart   # 下载服务
│   ├── language_service.dart   # 语言服务
│   └── localized_data.dart     # 本地化数据
├── widgets/                     # 组件
│   ├── beifa_logo.dart         # 贝发Logo组件
│   ├── download_dialog.dart    # 下载对话框
│   ├── featured_banner.dart    # 特色横幅
│   ├── footer_widget.dart      # 底部组件
│   ├── header_widget.dart      # 头部组件
│   ├── product_card.dart       # 产品卡片
│   └── translate_icon.dart     # 翻译图标
└── l10n/                        # 国际化资源
    ├── app_en.arb              # 英文资源
    └── app_zh.arb              # 中文资源
```

## 开发环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- iOS开发：Xcode（iOS 13.0+）
- Android开发：Android Studio（最新版本）
- macOS开发：Xcode（macOS支持）

## 运行项目

### 安装依赖
```bash
flutter pub get
```

### iOS运行
```bash
flutter run -d ios
```

### Android运行
```bash
flutter run -d android
```

### macOS运行
```bash
flutter run -d macos
```

## 版本信息

- **当前版本**：1.0.0+1
- **发布状态**：不发布到pub.dev

## 版权信息

© 贝发集团股份有限公司 浙ICP备11016667号

---

*本项目由南京魔数团开发维护*