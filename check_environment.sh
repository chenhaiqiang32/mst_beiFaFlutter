#!/bin/bash

# 环境检查脚本 - 检查Flutter开发环境

echo "🔍 检查Flutter开发环境..."

# 检查Flutter
echo ""
echo "📱 检查Flutter SDK..."
if command -v flutter &> /dev/null; then
    echo "✅ Flutter已安装"
    flutter --version
else
    echo "❌ Flutter未安装"
    echo "💡 运行 ./install_flutter.sh 进行安装"
fi

# 检查Dart
echo ""
echo "🎯 检查Dart SDK..."
if command -v dart &> /dev/null; then
    echo "✅ Dart已安装"
    dart --version
else
    echo "❌ Dart未安装（通常随Flutter一起安装）"
fi

# 检查Xcode
echo ""
echo "🍎 检查iOS开发环境..."
if command -v xcodebuild &> /dev/null; then
    echo "✅ Xcode已安装"
    xcodebuild -version
else
    echo "❌ Xcode未安装"
    echo "💡 请从App Store安装Xcode"
fi

# 检查Android Studio
echo ""
echo "🤖 检查Android开发环境..."
if [ -d "/Applications/Android Studio.app" ]; then
    echo "✅ Android Studio已安装"
else
    echo "❌ Android Studio未安装"
    echo "💡 请从官网下载安装: https://developer.android.com/studio"
fi

# 检查Android SDK
echo ""
echo "📱 检查Android SDK..."
if [ -d "$HOME/Library/Android/sdk" ]; then
    echo "✅ Android SDK已安装"
    echo "📍 位置: $HOME/Library/Android/sdk"
else
    echo "❌ Android SDK未找到"
    echo "💡 请安装Android Studio并配置SDK"
fi

# 检查环境变量
echo ""
echo "🔧 检查环境变量..."
if [[ "$PATH" == *"flutter"* ]]; then
    echo "✅ Flutter在PATH中"
else
    echo "❌ Flutter不在PATH中"
    echo "💡 请配置环境变量"
fi

if [[ "$PATH" == *"Android"* ]]; then
    echo "✅ Android SDK在PATH中"
else
    echo "❌ Android SDK不在PATH中"
    echo "💡 请配置ANDROID_HOME环境变量"
fi

# 运行Flutter Doctor
echo ""
echo "🏥 运行Flutter Doctor检查..."
if command -v flutter &> /dev/null; then
    flutter doctor
else
    echo "❌ 无法运行flutter doctor（Flutter未安装）"
fi

echo ""
echo "📋 总结："
echo "如果所有检查都通过，您可以运行项目："
echo "  ./run.sh"
echo ""
echo "如果有问题，请参考："
echo "  cat FLUTTER_INSTALLATION.md"




