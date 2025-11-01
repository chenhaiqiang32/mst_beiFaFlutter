# Android 真机调试指南

## 问题排查步骤

### 1. 检查 USB 连接
- 使用 **USB 数据线**连接手机和电脑（不要使用充电线）
- 确保 USB 线支持数据传输
- 尝试更换 USB 端口或 USB 线

### 2. 在手机上启用开发者选项

#### Android 设备：
1. 进入 **设置** > **关于手机**
2. 连续点击 **版本号** 7次，直到出现"您已成为开发者"
3. 返回设置，找到 **开发者选项**
4. 启用以下选项：
   - ✅ **USB 调试**（最重要）
   - ✅ **USB 安装**
   - ✅ **USB 调试（安全设置）**（某些设备需要）

### 3. 允许 USB 调试授权
- 首次连接时，手机会弹出"允许 USB 调试吗？"对话框
- 勾选"始终允许来自这台计算机"
- 点击 **允许**

### 4. 检查 ADB 连接状态

```bash
# 重启 ADB 服务
adb kill-server
adb start-server

# 检查设备连接
adb devices

# 如果看到 "unauthorized"，说明需要授权
# 如果看到 "device"，说明已连接成功
```

### 5. 检查 Flutter 设备列表

```bash
flutter devices

# 应该能看到你的 Android 设备，例如：
# vivo X60 Pro (mobile) • ABC123DEF456 • android-arm64 • Android 13 (API 33)
```

### 6. 常见问题解决

#### 问题：设备显示 "unauthorized"
- **解决**：在手机上点击"允许 USB 调试"
- 取消勾选"撤销 USB 调试授权"，重新授权

#### 问题：设备显示 "offline"
- **解决**：重启 ADB 服务
  ```bash
  adb kill-server
  adb start-server
  ```

#### 问题：adb devices 看不到设备
- **解决**：
  1. 检查 USB 连接模式：选择"文件传输"或"MTP"模式（不要选择"仅充电"）
  2. 尝试其他 USB 端口
  3. 在 Mac 上：检查 **系统设置** > **隐私与安全性** > 允许 USB 设备访问

#### 问题：Flutter devices 看不到设备，但 adb devices 能看到
- **解决**：
  ```bash
  flutter doctor -v
  # 检查 Android toolchain 是否正常
  # 确保 Android SDK 已正确配置
  ```

### 7. Mac 特定问题

如果设备已连接但无法识别：
1. 打开 **系统设置** > **隐私与安全性**
2. 检查是否需要允许 USB 设备访问
3. 某些情况下需要安装手机厂商的 USB 驱动程序（如小米、华为等）

### 8. 使用无线调试（Android 11+）

如果 USB 连接有问题，可以尝试无线调试：

```bash
# 1. 确保手机和电脑在同一 WiFi 网络
# 2. 在手机上启用"无线调试"
# 3. 获取 IP 地址和端口
adb connect <手机IP>:<端口>

# 例如：adb connect 192.168.1.100:5555
```

### 9. 测试连接

```bash
# 检查设备详细信息
adb devices -l

# 运行 Flutter 应用
flutter run -d <设备ID>

# 或让 Flutter 自动选择
flutter run
```

## 验证设备已连接

运行以下命令，应该能看到你的 Android 设备：

```bash
flutter devices
```

输出示例：
```
Found 2 connected devices:
  Android SDK built for arm64 (mobile) • emulator-5554 • android-arm64  • Android 13 (API 33) (emulator)
  vivo X60 Pro (mobile)                • ABC123DEF456  • android-arm64  • Android 13 (API 33)
```

## 下一步

一旦设备显示在 `flutter devices` 列表中，就可以运行：

```bash
flutter run -d <你的设备ID>
```

例如：
```bash
flutter run -d ABC123DEF456
```

