#!/bin/bash

# Flutter SDK 安装脚本 - macOS版本
# 适用于iOS和Android开发

echo "🚀 开始安装Flutter SDK for macOS..."

# 检查系统架构
ARCH=$(uname -m)
echo "📱 检测到系统架构: $ARCH"

# 设置安装目录
FLUTTER_DIR="$HOME/flutter"
FLUTTER_BIN="$FLUTTER_DIR/bin"

# 检查是否已安装Flutter
if command -v flutter &> /dev/null; then
    echo "✅ Flutter已安装，版本信息："
    flutter --version
    echo ""
    echo "🔍 检查Flutter环境配置..."
    flutter doctor
    exit 0
fi

echo "📥 下载Flutter SDK..."

# 根据架构选择下载链接
if [[ "$ARCH" == "arm64" ]]; then
    # Apple Silicon (M1/M2)
    FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.24.5-stable.tar.xz"
    echo "🍎 检测到Apple Silicon芯片，下载ARM64版本"
else
    # Intel
    FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.24.5-stable.tar.xz"
    echo "💻 检测到Intel芯片，下载Intel版本"
fi

# 创建临时目录
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# 下载Flutter SDK
echo "⬇️  正在下载Flutter SDK..."
curl -L "$FLUTTER_URL" -o flutter.tar.xz

if [ $? -ne 0 ]; then
    echo "❌ 下载失败，请检查网络连接"
    exit 1
fi

# 解压Flutter SDK
echo "📦 正在解压Flutter SDK..."
tar -xf flutter.tar.xz

# 移动到目标目录
echo "📁 正在安装到 $FLUTTER_DIR..."
if [ -d "$FLUTTER_DIR" ]; then
    rm -rf "$FLUTTER_DIR"
fi
mv flutter "$FLUTTER_DIR"

# 清理临时文件
cd "$HOME"
rm -rf "$TEMP_DIR"

echo "✅ Flutter SDK安装完成！"

# 配置环境变量
echo "🔧 配置环境变量..."

# 检测当前使用的shell
SHELL_NAME=$(basename "$SHELL")

if [[ "$SHELL_NAME" == "zsh" ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL_NAME" == "bash" ]]; then
    SHELL_CONFIG="$HOME/.bash_profile"
else
    SHELL_CONFIG="$HOME/.profile"
fi

echo "📝 检测到shell: $SHELL_NAME"
echo "📝 配置文件: $SHELL_CONFIG"

# 添加Flutter到PATH
if ! grep -q "flutter/bin" "$SHELL_CONFIG" 2>/dev/null; then
    echo "" >> "$SHELL_CONFIG"
    echo "# Flutter SDK" >> "$SHELL_CONFIG"
    echo "export PATH=\"\$PATH:$FLUTTER_BIN\"" >> "$SHELL_CONFIG"
    echo "✅ 已添加Flutter到PATH"
else
    echo "ℹ️  Flutter已在PATH中"
fi

# 验证安装
echo "🔍 验证Flutter安装..."
export PATH="$PATH:$FLUTTER_BIN"

# 检查Flutter是否可执行
if [ -f "$FLUTTER_BIN/flutter" ]; then
    echo "✅ Flutter文件已安装到: $FLUTTER_BIN/flutter"
    "$FLUTTER_BIN/flutter" --version
    
    if [ $? -eq 0 ]; then
        echo "✅ Flutter安装成功！"
        echo ""
        echo "📝 请重新打开终端或运行以下命令使环境变量生效："
        echo "   source $SHELL_CONFIG"
        echo ""
        echo "然后可以运行："
        echo "   flutter --version"
        echo "   ./run.sh"
    else
        echo "❌ Flutter安装失败"
        exit 1
    fi
else
    echo "❌ Flutter文件未找到: $FLUTTER_BIN/flutter"
    exit 1
fi

echo ""
echo "🎯 下一步：安装开发工具"
echo ""

# 检查Xcode
echo "🍎 检查Xcode安装..."
if command -v xcodebuild &> /dev/null; then
    echo "✅ Xcode已安装"
    echo "📋 接受Xcode许可协议..."
    sudo xcodebuild -license accept
else
    echo "❌ 请从App Store安装Xcode"
    echo "🔗 下载链接: https://apps.apple.com/us/app/xcode/id497799835"
fi

# 检查Android Studio
echo ""
echo "🤖 检查Android Studio安装..."
if [ -d "/Applications/Android Studio.app" ]; then
    echo "✅ Android Studio已安装"
else
    echo "❌ 请安装Android Studio"
    echo "🔗 下载链接: https://developer.android.com/studio"
fi

echo ""
echo "🔍 运行Flutter Doctor检查..."
flutter doctor

echo ""
echo "🎉 安装完成！"
echo ""
echo "📋 后续步骤："
echo "1. 如果提示需要安装Android Studio，请从官网下载安装"
echo "2. 如果提示需要安装Xcode，请从App Store安装"
echo "3. 运行 'flutter doctor --android-licenses' 接受Android许可"
echo "4. 重新打开终端或运行 'source $SHELL_CONFIG'"
echo "5. 然后可以运行 'flutter run' 启动项目"
echo ""
echo "🚀 现在可以运行项目了："
echo "   cd beifa_app_platform"
echo "   flutter pub get"
echo "   flutter run"
