# 使用基于 Alpine 的 Go 镜像，体积小
FROM golang:1.24-alpine

# 安装 git (Alpine 默认不带 git)
# 如果你需要 gcc/g++ 进行 CGO 编译，请将下行改为: apk add --no-cache git build-base
RUN apk add --no-cache git

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV GO111MODULE=on
ENV CGO_ENABLED=0
# 设置时区为上海（可选，方便查看日志）
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 暴露端口范围
EXPOSE 9900-9999

# 将本地的启动脚本复制到容器中
COPY entrypoint.sh /usr/local/bin/

# 赋予脚本执行权限 (防止 Windows 下丢失权限)
RUN chmod +x /usr/local/bin/entrypoint.sh

# 设置容器启动入口
ENTRYPOINT ["entrypoint.sh"]