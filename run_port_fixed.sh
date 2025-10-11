#!/bin/bash

# 贝发APP导航平台 - 固定端口运行脚本
# 支持Web和macOS平台，使用固定端口

echo "🚀 贝发APP导航平台 - 固定端口启动"
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

# 显示平台选择菜单
echo ""
echo "请选择运行平台:"
echo "1) Web (Chrome浏览器)"
echo "2) macOS (桌面应用)"
echo "3) 同时运行Web和macOS"
echo ""
read -p "请输入选择 (1-3): " choice

case $choice in
    1)
        echo "🌐 启动Web应用 (固定端口)..."
        echo "📍 Web端口: 8080"
        echo "🔧 调试端口: 8888"
        echo "📱 应用地址: http://localhost:8080"
        echo ""
        flutter run -d chrome \
            --web-port=8080 \
            --dart-vm-service-port=8888 \
            --web-hostname=localhost
        ;;
    2)
        echo "🍎 启动macOS应用 (固定端口)..."
        echo "🔧 调试端口: 8888"
        echo ""
        flutter run -d macos \
            --dart-vm-service-port=8888
        ;;
    3)
        echo "🚀 同时启动Web和macOS应用..."
        echo "📍 Web端口: 8080"
        echo "🔧 调试端口: 8888 (Web)"
        echo "🔧 调试端口: 8889 (macOS)"
        echo "📱 Web应用地址: http://localhost:8080"
        echo ""
        
        # 启动Web应用
        flutter run -d chrome \
            --web-port=8080 \
            --dart-vm-service-port=8888 \
            --web-hostname=localhost &
        
        # 等待一下再启动macOS应用
        sleep 3
        
        # 启动macOS应用
        flutter run -d macos \
            --dart-vm-service-port=8889 &
        
        # 等待用户中断
        echo "按 Ctrl+C 停止所有应用"
        wait
        ;;
    *)
        echo "❌ 无效选择，请重新运行脚本"
        exit 1
        ;;
esac

echo ""
echo "🎉 应用已停止"
