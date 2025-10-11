# 🔧 固定端口配置说明

## ✅ 已配置的固定端口

### Web应用端口
- **Web端口**: `8080`
- **调试端口**: `8888`
- **访问地址**: `http://localhost:8080`
- **调试地址**: `http://localhost:8888`

### macOS应用端口
- **调试端口**: `8888` (单独运行) 或 `8889` (同时运行)

## 🚀 运行脚本

### 1. Web应用 (固定端口)
```bash
./run_fixed_port.sh
```
- 使用固定端口8080启动Web应用
- 调试端口8888
- 自动打开Chrome浏览器

### 2. macOS应用 (固定端口)
```bash
./run_macos_fixed_port.sh
```
- 使用固定端口8888启动macOS应用
- 自动打开macOS桌面应用

### 3. 通用脚本 (多平台选择)
```bash
./run_port_fixed.sh
```
- 提供平台选择菜单
- 支持Web、macOS或同时运行
- 智能端口分配

## 📋 Flutter命令参数说明

### Web应用固定端口命令
```bash
flutter run -d chrome \
    --web-port=8080 \
    --dart-vm-service-port=8888 \
    --web-hostname=localhost
```

### macOS应用固定端口命令
```bash
flutter run -d macos \
    --dart-vm-service-port=8888
```

### 参数说明
- `--web-port=8080`: 设置Web应用端口为8080
- `--dart-vm-service-port=8888`: 设置调试服务端口为8888
- `--web-hostname=localhost`: 设置Web主机名为localhost

## 🎯 端口优势

### 1. 固定访问地址
- Web应用始终在 `http://localhost:8080` 访问
- 不需要每次查看终端输出获取新端口
- 便于书签保存和分享

### 2. 调试端口稳定
- 调试端口固定为8888
- DevTools地址固定为 `http://localhost:8888`
- 便于开发工具配置

### 3. 多平台支持
- Web和macOS可以同时运行
- 自动分配不同的调试端口
- 避免端口冲突

## 🔧 自定义端口

如果需要修改端口，可以编辑脚本文件：

### 修改Web端口
```bash
# 将8080改为其他端口，如9090
flutter run -d chrome --web-port=9090 --dart-vm-service-port=8888
```

### 修改调试端口
```bash
# 将8888改为其他端口，如9999
flutter run -d chrome --web-port=8080 --dart-vm-service-port=9999
```

## 📱 使用场景

### 开发调试
```bash
# 启动Web应用进行开发调试
./run_fixed_port.sh
```

### 桌面测试
```bash
# 启动macOS应用进行桌面测试
./run_macos_fixed_port.sh
```

### 多平台测试
```bash
# 同时运行Web和macOS应用
./run_port_fixed.sh
# 选择选项3
```

## 🎉 端口配置完成

现在您可以使用固定端口启动应用：

✅ **Web应用**: `http://localhost:8080`  
✅ **调试工具**: `http://localhost:8888`  
✅ **macOS应用**: 调试端口8888  
✅ **多平台支持**: 自动端口分配  

不再需要每次查看终端输出获取新的端口号！🎊
