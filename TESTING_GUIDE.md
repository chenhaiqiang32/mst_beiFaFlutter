# Android 下载功能测试指南

## 修复说明

已修复 Android 10+ 设备上点击下载按钮时：
- ❌ 没有弹出存储权限申请对话框
- ❌ 下载没有开始
- ❌ 进度条不更新

## 测试步骤

### 1. 准备测试设备

需要在以下 Android 版本上测试：
- ✅ Android 10 (API 29)
- ✅ Android 11 (API 30)
- ✅ Android 12 (API 31)
- ✅ Android 13 (API 33)
- ✅ Android 14 (API 34)
- ✅ Android 15+ (API 35+)

### 2. 清理旧版本

**重要**：在测试设备上卸载旧版本应用，避免缓存问题

```bash
# 在 Android 设备上
adb uninstall com.example.beifa_app_platform
```

### 3. 安装新版本

```bash
# 在项目目录下
flutter run -d <device-id>
```

或使用 Android Studio / VS Code 的调试功能

### 4. 测试下载功能

#### 测试流程

1. **打开应用**
   - 启动应用
   - 浏览到产品列表
   - 选择任意一个产品

2. **点击下载按钮**
   - 点击产品详情页的下载按钮
   - **观察**：
     - ✅ 应该立即显示下载对话框
     - ✅ 进度条应该立即开始更新
     - ✅ 不需要任何权限对话框弹出

3. **监控下载进度**
   - 观察进度条是否平滑更新
   - 控制台应该打印下载进度日志
   - 下载完成后，进度条应该显示 100%

4. **验证下载的文件**
   - 下载完成后，使用文件管理器找到：
     - 路径：`/storage/emulated/0/Android/data/com.example.beifa_app_platform/files/Download/`
   - 或者：
     - 设置 > 存储 > 搜索 "beifa_app_platform"
     - 找到应用文件目录中的 Download 文件夹

5. **安装 APK**
   - 点击下载的 APK 文件
   - 验证是否可以正常安装

### 5. 检查日志

在控制台查看日志输出：

```bash
# 应该看到类似的日志
flutter: [DetailScreen] Download clicked for product=1 name=Origins Translate
flutter: [DetailScreen] Detected Android. Showing DownloadDialog for url=...
flutter: [DownloadDialog] getExternalStorageDirectory -> /storage/emulated/0/Android/data/com.example.beifa_app_platform/files
flutter: [DownloadDialog] Start download. url=... fileName=... filePath=...
flutter: [DownloadDialog] Progress 2% (xxx/xxx)
flutter: [DownloadDialog] Progress 4% (xxx/xxx)
...
flutter: [DownloadDialog] Progress 100% (xxx/xxx)
flutter: [DownloadDialog] Download completed.
```

**不应该看到**：
- ❌ `Requesting storage permission...`
- ❌ `Storage permission isGranted=false`
- ❌ `Failed to get external storage directory`

### 6. 测试多个产品

测试下载多个不同的产品，确保：
- 每个产品的下载都正常
- 文件大小不同的产品都能正常下载
- 下载速度快的和慢的都能正常显示进度

## 已知问题（已修复）

### 之前的错误日志

```
I/flutter ( 6389): [DownloadDialog] Storage permission isGranted=false
```

**修复**：移除了 `Permission.storage.request()` 调用，改用应用专属目录

### 当前实现

- ✅ 使用应用专属外部存储目录
- ✅ 不需要任何权限
- ✅ 适用于所有 Android 版本
- ✅ 进度条实时更新
- ✅ 文件正常保存

## 故障排除

### 问题 1：下载仍然不开始

**可能原因**：
- 没有卸载旧版本
- 缓存问题

**解决方案**：
```bash
adb uninstall com.example.beifa_app_platform
flutter clean
flutter pub get
flutter run -d <device-id>
```

### 问题 2：进度条不更新

**检查**：
- 控制台是否有错误日志
- 网络连接是否正常
- APK URL 是否可以访问

**解决方案**：
- 检查网络连接
- 验证 APK 下载链接是否有效
- 查看控制台的详细错误信息

### 问题 3：文件找不到

**可能原因**：
- 文件下载到了不同的路径
- 文件管理器没有权限访问应用目录

**解决方案**：
- 使用 `adb` 命令查找文件：
  ```bash
  adb shell ls -la /storage/emulated/0/Android/data/com.example.beifa_app_platform/files/Download/
  ```
- 使用 Solid Explorer 或类似的文件管理器
- 在 Android 设置中查找应用存储

### 问题 4：无法安装 APK

**可能原因**：
- Android 8.0+ 需要允许"未知来源"安装
- 文件损坏

**解决方案**：
1. 设置 > 安全 > 启用"允许从此来源安装"
2. 重新下载文件

## 回归测试

在修复后，确保以下功能仍然正常：

- [ ] iOS 下载（App Store 打开）功能正常
- [ ] Web 平台显示适当的提示
- [ ] 产品列表正常显示
- [ ] 产品详情页正常显示
- [ ] 语言切换功能正常
- [ ] 其他 UI 功能没有受到影响

## 性能测试

测试下载大文件（> 100MB）：
- 进度条更新频率
- 内存占用
- 下载速度
- 应用响应性

## 总结

修复的核心改动：
1. **移除了权限请求**：使用应用专属目录，无需权限
2. **改进的目录管理**：在应用专属目录下创建 Download 子目录
3. **更好的错误处理**：添加了详细的日志输出
4. **兼容性改进**：适用于所有 Android 版本

测试完成后，请记录：
- ✅ 测试的设备型号和 Android 版本
- ✅ 测试结果（通过/失败）
- ✅ 遇到的任何问题
- ✅ 建议的改进

