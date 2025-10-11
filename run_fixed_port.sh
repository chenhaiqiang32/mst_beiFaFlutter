#!/bin/bash

# 贝发APP导航平台 - 固定端口运行脚本
# 使用固定端口避免每次启动都生成新端口

echo "🚀 启动贝发APP导航平台 (固定端口)"
echo "=================================="

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    echo "💡 可以运行 ./install_flutter_simple.sh 进行安装"
    exit 1
fi

# 进入项目目录
cd "$(dirname "$0")"

echo "📁 项目目录: $(pwd)"
echo "🔧 检查Flutter环境..."

# 检查Flutter环境
flutter doctor --no-version-check > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Flutter环境检查失败"
    exit 1
fi

echo "✅ Flutter环境正常"
echo "📦 获取依赖包..."

# 获取依赖
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ 依赖获取失败"
    exit 1
fi

echo "✅ 依赖获取完成"
echo "🌐 启动Web应用 (固定端口)..."

# 使用固定端口启动应用
echo "📍 Web端口: 8080"
echo "🔧 调试端口: 8888"
echo "📱 应用地址: http://localhost:8080"
echo ""

flutter run -d chrome \
    --web-port=8080 \
    --dart-vm-service-port=8888 \
    --web-hostname=localhost

echo ""
echo "🎉 应用已停止"
