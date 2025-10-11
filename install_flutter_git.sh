#!/bin/bash

# 使用Git安装Flutter脚本（最可靠的方式）

echo "🚀 开始安装Flutter SDK (使用Git方式)..."

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

# 检查git是否安装
if ! command -v git &> /dev/null; then
    echo "❌ Git未安装，请先安装Git"
    echo "💡 安装Git: brew install git"
    exit 1
fi

echo "📥 使用Git克隆Flutter仓库..."
echo "📍 安装位置: $FLUTTER_DIR"

# 克隆Flutter仓库
git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"

if [ $? -ne 0 ]; then
    echo "❌ Git克隆失败，请检查网络连接"
    exit 1
fi

echo "✅ Flutter仓库克隆成功！"

# 验证安装
echo "🔍 验证安装..."
if [ -f "$FLUTTER_BIN/flutter" ]; then
    echo "✅ Flutter文件已安装到: $FLUTTER_BIN/flutter"
    
    # 给Flutter执行权限
    chmod +x "$FLUTTER_BIN/flutter"
    
    # 测试Flutter命令
    echo "📱 版本信息:"
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




