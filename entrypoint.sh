#!/bin/sh
set -e

# 定义项目目录和仓库地址
REPO_URL="https://github.com/rei0721/ghhook-server.git"
PROJECT_DIR="/app/source" # 源码放在子目录，保持 /app 整洁
BINARY_PATH="/app/gh"

echo ">>> 检查网络连接..."
# 简单检查，确保能连上 GitHub，如果环境特殊可能需要配置代理
git config --global http.sslVerify false

echo ">>> 正在处理源码..."
if [ ! -d "$PROJECT_DIR/.git" ]; then
    echo ">>> 目录为空，正在克隆仓库..."
    # 强制创建目录
    mkdir -p "$PROJECT_DIR"
    git clone "$REPO_URL" "$PROJECT_DIR"
else
    echo ">>> 仓库已存在，正在拉取最新代码..."
    cd "$PROJECT_DIR"
    git fetch origin
    git reset --hard origin/main || git reset --hard origin/master
fi

# 进入项目目录
cd "$PROJECT_DIR"

echo ">>> 安装依赖..."
# 设置 Go 代理，防止国内网络拉取失败
export GOPROXY=https://goproxy.cn,direct
go mod tidy

echo ">>> 开始构建..."
# 将二进制文件输出到 /app/gh
go build -o "$BINARY_PATH" .

echo ">>> 赋予执行权限..."
chmod +x "$BINARY_PATH"

echo ">>> 启动应用程序..."
echo ">>> 监听端口范围: 9900-9999"
# 执行二进制文件
exec "$BINARY_PATH"