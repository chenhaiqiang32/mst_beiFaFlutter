#!/bin/bash

# 修复版Flutter安装脚本

echo "🚀 开始安装Flutter SDK..."

# 设置安装目录
FLUTTER_DIR="$HOME/flutter"
FLUTTER_BIN="$FLUTTER_DIR/bin"

# 检查是否已安装
if [ -d "$FLUTTER_DIR" ]; then
    echo "✅ Flutter已安装，位置: $FLUTTER_DIR"
    if [ -f "$FLUTTER_BIN/flutter" ]; then
        echo "📱 版本信息:"
        "$FLUTTER_BIN/flutter" --version
    fi
    exit 0
fi

# 检测系统架构
ARCH=$(uname -m)
echo "📱 检测到系统架构: $ARCH"

# 根据架构选择下载链接
if [[ "$ARCH" == "arm64" ]]; then
    FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.24.5-stable.tar.xz"
    echo "🍎 下载Apple Silicon版本"
else
    FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.24.5-stable.tar.xz"
    echo "💻 下载Intel版本"
fi

# 创建临时目录
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "⬇️  正在下载Flutter SDK..."
echo "🔗 下载链接: $FLUTTER_URL"

# 使用wget或curl下载
if command -v wget &> /dev/null; then
    wget -O flutter.tar.xz "$FLUTTER_URL"
else
    curl -L "$FLUTTER_URL" -o flutter.tar.xz
fi

# 检查下载是否成功
if [ ! -f "flutter.tar.xz" ] || [ ! -s "flutter.tar.xz" ]; then
    echo "❌ 下载失败，尝试备用下载方式..."
    
    # 尝试使用git clone作为备用方案
    echo "🔄 尝试使用git clone..."
    git clone https://github.com/flutter/flutter.git -b stable
    if [ $? -eq 0 ] && [ -d "flutter" ]; then
        echo "✅ Git clone成功"
    else
        echo "❌ 所有下载方式都失败了"
        echo "💡 请检查网络连接或手动下载Flutter"
        echo "🔗 手动下载链接: $FLUTTER_URL"
        exit 1
    fi
else
    echo "📦 正在解压..."
    tar -xf flutter.tar.xz
    
    if [ $? -ne 0 ]; then
        echo "❌ 解压失败，文件可能损坏"
        echo "💡 请重新下载或检查网络连接"
        exit 1
    fi
fi

# 检查解压结果
if [ ! -d "flutter" ]; then
    echo "❌ 解压后未找到flutter目录"
    exit 1
fi

echo "📁 正在安装到 $FLUTTER_DIR..."
mv flutter "$FLUTTER_DIR"

# 清理临时文件
cd "$HOME"
rm -rf "$TEMP_DIR"

echo "✅ Flutter SDK安装完成！"

# 验证安装
echo "🔍 验证安装..."
if [ -f "$FLUTTER_BIN/flutter" ]; then
    echo "✅ Flutter文件已安装到: $FLUTTER_BIN/flutter"
    
    # 给Flutter执行权限
    chmod +x "$FLUTTER_BIN/flutter"
    
    # 测试Flutter命令
    "$FLUTTER_BIN/flutter" --version
    
    if [ $? -eq 0 ]; then
        echo "✅ Flutter安装成功！"
        
        # 配置环境变量
        echo "🔧 配置环境变量..."
        
        # 检测shell类型
        if [[ "$SHELL" == *"zsh"* ]]; then
            SHELL_CONFIG="$HOME/.zshrc"
        else
            SHELL_CONFIG="$HOME/.bash_profile"
        fi
        
        # 添加PATH
        if ! grep -q "flutter/bin" "$SHELL_CONFIG" 2>/dev/null; then
            echo "" >> "$SHELL_CONFIG"
            echo "# Flutter SDK" >> "$SHELL_CONFIG"
            echo "export PATH=\"\$PATH:$FLUTTER_BIN\"" >> "$SHELL_CONFIG"
            echo "✅ 已添加Flutter到PATH"
        fi
        
        echo ""
        echo "🎉 安装完成！"
        echo ""
        echo "📝 下一步："
        echo "1. 重新打开终端，或运行: source $SHELL_CONFIG"
        echo "2. 验证安装: flutter --version"
        echo "3. 运行项目: ./run.sh"
        echo ""
        echo "🛠️  开发工具安装："
        echo "- iOS: 从App Store安装Xcode"
        echo "- Android: 从官网下载Android Studio"
        echo ""
        echo "🔍 环境检查: flutter doctor"
        
    else
        echo "❌ Flutter安装失败"
        exit 1
    fi
else
    echo "❌ Flutter文件未找到: $FLUTTER_BIN/flutter"
    exit 1
fi




