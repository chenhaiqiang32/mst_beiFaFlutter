# iOS 真机调试指南

## 问题排查步骤

### 1. 检查 USB 连接
- 使用 **USB 数据线**连接 iPhone 和 Mac（确保使用原装或 MFI 认证的线）
- 确保 USB 线支持数据传输
- 尝试更换 USB 端口或 USB 线

### 2. 在 iPhone 上启用开发者模式（iOS 16+）

#### 重要：iOS 16 及以上版本需要启用开发者模式

1. 进入 **设置** > **隐私与安全性**
2. 向下滚动找到 **开发者模式**
3. 启用 **开发者模式** 开关
4. **重启 iPhone**（系统会提示）
5. 重启后，系统会再次弹出确认对话框，选择 **开启**

#### 对于 iOS 15 及更早版本：
- 不需要开发者模式设置，但需要信任电脑

### 3. 信任此电脑

首次连接 iPhone 到 Mac 时：

1. iPhone 会弹出 "要信任此电脑吗？" 对话框
2. 在 iPhone 上点击 **信任**
3. 输入 iPhone 的解锁密码进行确认

#### 如果没有弹出信任对话框：
1. 打开 **Xcode**
2. 重新连接 iPhone（拔掉再插上）
3. 在 Xcode 中：**Window** > **Devices and Simulators**
4. 如果看到设备状态为 "未信任"，按照提示操作

### 4. 检查设备连接状态

#### 在 Xcode 中检查：
1. 打开 **Xcode**
2. 选择 **Window** > **Devices and Simulators**
3. 在左侧设备列表中查看你的 iPhone
4. 设备状态应该显示为绿色（已连接）

#### 在终端中检查：
```bash
# 使用 instruments 命令检查设备
xcrun xctrace list devices

# 或使用 ios-deploy（如果已安装）
ios-deploy -c
```

### 5. 检查 Flutter 设备列表

```bash
flutter devices

# 应该能看到你的 iOS 设备，例如：
# 刘丹的iPhone (mobile) • 00008030-000A1D0E12345678 • ios • com.apple.CoreSimulator.SimRuntime.iOS-16-2 (simulator)
```

### 6. 常见问题解决

#### 问题：Xcode 显示设备为 "未信任" 或 "未授权"
- **解决**：
  1. 在 iPhone 上：**设置** > **通用** > **VPN与设备管理**
  2. 查看是否有电脑的证书，确保已信任
  3. 重新连接设备并在 iPhone 上点击 "信任此电脑"

#### 问题：需要注册设备或开发者账号问题
- **解决**：
  1. 在 Xcode 中：**Xcode** > **Settings** > **Accounts**
  2. 添加你的 Apple ID（用于免费开发者账号）或付费开发者账号
  3. 在项目设置中：**Signing & Capabilities** > 选择你的 Team

#### 问题：设备连接后显示但不稳定
- **解决**：
  ```bash
  # 重启 iOS 设备连接服务
  killall Xcode
  killall com.apple.CoreSimulator.CoreSimulatorService
  
  # 重新连接设备
  ```

#### 问题：Flutter devices 看不到设备，但 Xcode 能看到
- **解决**：
  ```bash
  # 检查 Flutter iOS 工具链
  flutter doctor -v
  
  # 确保 CocoaPods 已安装并更新
  cd ios
  pod install
  cd ..
  
  # 重新检查设备
  flutter devices
  ```

### 7. 开发者模式相关提示

如果看到以下提示：
```
To use '刘丹的iPhone' for development, enable Developer Mode in Settings → Privacy & Security on the device.
```

**解决步骤**：
1. 在 iPhone 上：**设置** > **隐私与安全性** > **开发者模式**
2. 启用开发者模式
3. **重启 iPhone**（必须重启才能生效）
4. 重启后再次确认开启开发者模式
5. 重新连接设备到 Mac

### 8. 代码签名证书问题解决 ⭐

#### 错误信息：
```
No valid code signing certificates were found
No development certificates available to code sign app for device deployment
```

这是 iOS 真机调试中最常见的问题之一。以下是完整的解决步骤：

#### 解决方案（步骤详解）：

**步骤 1：在 Xcode 中登录 Apple ID**

1. 打开 **Xcode**
2. 选择 **Xcode** > **Settings**（或 **Preferences**）
3. 点击 **Accounts** 标签
4. 点击左下角的 **+** 按钮
5. 选择 **Apple ID**
6. 输入你的 Apple ID 和密码
7. 点击 **Sign In**

> **注意**：如果你没有付费的 Apple Developer 账号（$99/年），可以使用免费的 Apple ID。免费账号的限制：
> - 证书有效期 7 天（需要重新生成）
> - 最多注册 3 个设备
> - 只能安装 3 个应用

**步骤 2：打开 Flutter 项目的 Xcode 配置**

```bash
# 在项目根目录执行（注意是 .xcworkspace 不是 .xcodeproj）
open ios/Runner.xcworkspace
```

**步骤 3：配置代码签名**

1. 在 Xcode 左侧导航栏中，选择 **Runner** 项目（最顶部的蓝色图标）
2. 在中间面板中，选择 **Runner** target（不是项目，是 target）
3. 点击 **Signing & Capabilities** 标签

**步骤 4：配置签名设置**

在 **Signing & Capabilities** 标签中：

1. **勾选 "Automatically manage signing"**
   - 这会自动管理证书和配置文件

2. **选择 Team**
   - 在 **Team** 下拉菜单中选择你的 Apple ID
   - 如果下拉菜单为空或显示 "Add an Account..."：
     - 参考步骤 1，先登录 Apple ID
     - 然后返回这里刷新

3. **检查 Bundle Identifier**
   - 确保 **Bundle Identifier** 是唯一的（例如：`com.yourname.beifaAppPlatform`）
   - 默认可能是 `com.example.beifaAppPlatform`，需要修改为唯一的 ID
   - 格式：`com.公司或名字.应用名`（小写字母、数字、连字符）

**步骤 5：让 Xcode 自动创建证书和配置文件**

1. 勾选 "Automatically manage signing" 后，Xcode 会自动：
   - 创建 iOS Development Certificate（开发证书）
   - 创建 Provisioning Profile（配置文件）
   - 注册你的设备

2. 如果出现错误提示：
   - **"Your account already has a signing certificate"**：这表示证书已存在，点击 **Try Again**
   - **"Failed to register bundle identifier"**：需要修改 Bundle Identifier 为唯一值
   - **"No profiles for 'xxx' were found"**：Xcode 会自动创建，点击 **Try Again**

**步骤 6：验证签名配置**

在 **Signing & Capabilities** 标签中应该看到：
- ✅ **Automatically manage signing**：已勾选
- ✅ **Team**：显示你的 Apple ID 或团队名称
- ✅ **Signing Certificate**：显示 "Apple Development: your@email.com"
- ✅ **Provisioning Profile**：显示 "Xcode Managed Profile" 或类似内容

**步骤 7：在 iPhone 上信任开发证书**

证书创建后，首次安装应用到设备时：

1. 在 iPhone 上：**设置** > **通用** > **VPN与设备管理**（或 **设备管理**）
2. 找到你的开发者账号（显示为你的 Apple ID 邮箱）
3. 点击进入
4. 点击 **信任 "[你的 Apple ID]"**
5. 在弹出的确认对话框中点击 **信任**

**步骤 8：重新构建和运行**

```bash
# 清理构建
cd ios
xcodebuild clean
cd ..

# 或在 Xcode 中：Product > Clean Build Folder (Shift + Command + K)

# 重新运行 Flutter 应用
flutter run -d ios
```

#### 常见问题：

**问题 1：Team 下拉菜单显示 "Add an Account..."**
- **解决**：先在 Xcode Settings 中登录 Apple ID（参考步骤 1）

**问题 2：Bundle Identifier 已存在**
- **解决**：修改 Bundle Identifier 为唯一值，例如：
  - `com.yourname.beifaAppPlatform`
  - `com.yourcompany.beifaApp`

**问题 3：设备未注册**
- **解决**：
  1. 确保 iPhone 已连接并信任电脑
  2. 在 Xcode 中：**Window** > **Devices and Simulators**
  3. 选择你的设备，Xcode 会自动注册
  4. 如果显示 "未注册"，检查开发者模式是否已启用

**问题 4：证书过期（免费账号）**
- **解决**：免费账号证书有效期 7 天，过期后需要：
  1. 在 Xcode 中：**Xcode** > **Settings** > **Accounts**
  2. 选择你的 Apple ID
  3. 点击 **Download Manual Profiles**
  4. 重新运行应用，Xcode 会自动更新证书

**问题 5：超过 3 个设备限制（免费账号）**
- **解决**：
  1. 在 [Apple Developer Portal](https://developer.apple.com/account/resources/devices/list) 移除旧设备
  2. 或在 Xcode 中：**Window** > **Devices and Simulators**
  3. 右键点击不需要的设备，选择 **Unpair**

### 9. 代码签名设置（快速参考）

确保在 Xcode 中正确配置代码签名：

1. 打开项目：`ios/Runner.xcworkspace`（注意是 .xcworkspace 不是 .xcodeproj）
2. 选择 **Runner** target
3. 在 **Signing & Capabilities** 标签中：
   - 勾选 **Automatically manage signing**
   - 选择你的 **Team**（Apple ID）
   - 确保 **Bundle Identifier** 是唯一的

### 10. 测试连接

```bash
# 检查设备详细信息
flutter devices -v

# 运行 Flutter 应用到 iOS 设备
flutter run -d <设备ID>

# 或让 Flutter 自动选择
flutter run

# 如果设备是 iPhone，可以指定：
flutter run -d ios
```

### 11. 无线调试（iOS 13+）

iOS 支持无线调试，但需要先通过 USB 配对：

```bash
# 1. 先用 USB 连接设备
# 2. 在 Xcode 中：Window > Devices and Simulators
# 3. 选择设备，勾选 "Connect via network"
# 4. 断开 USB 后，设备会通过 WiFi 连接（需要在同一网络）
```

## 验证设备已连接

运行以下命令，应该能看到你的 iOS 设备：

```bash
flutter devices
```

输出示例：
```
Found 2 connected devices:
  iPhone 14 Pro (mobile)     • 00008030-000A1D0E12345678 • ios • com.apple.CoreSimulator.SimRuntime.iOS-16-2
  Simulator (mobile)         • B8F8F8F8-1234-5678-9ABC-DEF123456789 • ios • com.apple.CoreSimulator.SimRuntime.iOS-16-2 (simulator)
```

## 常见错误信息

### "Could not find the built application bundle"
- **原因**：Xcode 构建配置问题
- **解决**：在 Xcode 中清理构建（Product > Clean Build Folder），然后重新运行

### "No valid code signing certificate found" / "No valid code signing certificates were found"
- **原因**：缺少代码签名证书
- **解决**：详见上面的 **"8. 代码签名证书问题解决 ⭐"** 章节
- **快速解决**：
  1. 打开 `ios/Runner.xcworkspace`
  2. 选择 Runner target > Signing & Capabilities
  3. 勾选 "Automatically manage signing"
  4. 选择你的 Team（Apple ID）
  5. 确保 Bundle Identifier 唯一
  6. 在设备上信任证书：**设置** > **通用** > **VPN与设备管理** > 信任开发者证书

### "Device is not registered"
- **原因**：设备未添加到开发者账号
- **解决**：在 Xcode 中会自动注册，或手动在 Apple Developer 网站添加设备

## 下一步

一旦设备显示在 `flutter devices` 列表中，就可以运行：

```bash
flutter run -d <你的设备ID>
```

例如：
```bash
flutter run -d 00008030-000A1D0E12345678
```

## 参考资源

- [Flutter iOS 开发文档](https://docs.flutter.dev/deployment/ios)
- [Apple Developer 文档](https://developer.apple.com/documentation/)
- [Xcode 帮助文档](https://developer.apple.com/documentation/xcode)

