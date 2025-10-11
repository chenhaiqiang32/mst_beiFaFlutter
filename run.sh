#!/bin/bash

# 贝发集团智能产品APP导航平台 - 运行脚本

echo "🚀 启动贝发集团智能产品APP导航平台..."

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    echo ""
    echo "🚀 快速安装选项："
    echo "1. Git安装脚本: ./install_flutter_git.sh (最可靠)"
    echo "2. 修复版安装脚本: ./install_flutter_fixed.sh"
    echo "3. 简化安装脚本: ./install_flutter_simple.sh"
    echo "4. 完整安装脚本: ./install_flutter.sh"
    echo "5. 查看详细指南: cat FLUTTER_INSTALLATION.md"
    echo "6. 手动安装指南: cat MANUAL_INSTALL.md"
    echo ""
    echo "💡 推荐使用Git安装脚本（最可靠）："
    echo "   ./install_flutter_git.sh"
    echo ""
    read -p "选择安装方式 (1-6): " -n 1 -r
    echo
    case $REPLY in
        1)
            echo "🚀 启动Git安装..."
            ./install_flutter_git.sh
            ;;
        2)
            echo "🚀 启动修复版安装..."
            ./install_flutter_fixed.sh
            ;;
        3)
            echo "🚀 启动简化安装..."
            ./install_flutter_simple.sh
            ;;
        4)
            echo "🚀 启动完整安装..."
            ./install_flutter.sh
            ;;
        5)
            echo "📖 显示详细安装指南..."
            cat FLUTTER_INSTALLATION.md
            ;;
        6)
            echo "📖 显示手动安装指南..."
            cat MANUAL_INSTALL.md
            ;;
        *)
            echo "📖 请手动安装Flutter后重新运行此脚本"
            ;;
    esac
    exit 1
fi

# 检查Flutter版本
echo "📱 Flutter版本:"
flutter --version

# 获取依赖
echo "📦 获取项目依赖..."
flutter pub get

# 检查设备
echo "📱 检查可用设备..."
flutter devices

# 运行项目
echo "🎯 启动应用..."
flutter run

echo "✅ 应用启动完成！"

