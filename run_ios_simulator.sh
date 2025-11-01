#!/bin/bash

# iOS 模拟器运行脚本

echo "🍎 启动 iOS 模拟器..."

# 设置UTF-8编码
export LANG=en_US.UTF-8

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    exit 1
fi

# 获取依赖
echo "📦 获取项目依赖..."
flutter pub get

# 启动特定的 iOS 模拟器
echo "📱 启动 iPhone 17 Pro 模拟器..."
xcrun simctl boot "iPhone 17 Pro" 2>&1 || echo "模拟器可能已经在运行中"

# 打开 Simulator 应用
open -a Simulator

# 等待模拟器完全启动
echo "⏳ 等待模拟器启动..."
sleep 10

# 检查设备
echo "📱 检查可用设备..."
flutter devices

# 运行项目
echo "🎯 在 iOS 模拟器上运行应用..."
flutter run -d "iPhone 17 Pro"

echo "✅ 应用已在 iOS 模拟器上启动！"

