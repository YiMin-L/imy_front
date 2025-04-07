#!/bin/bash

# 构建 Docker 镜像
docker build -t imy-frontend:0405 --build-arg BACKEND_API_URL=http://127.0.0.1:8080 --build-arg BACKEND_WS_URL=ws://127.0.0.1:19000/ws -f Dockerfile .

# 停止并删除旧容器（如果存在）
docker stop imy-frontend 2>/dev/null || true
docker rm imy-frontend 2>/dev/null || true

# 运行新容器
docker run -d --name imy-frontend -p 8000:8000 -e BACKEND_API_URL=http://127.0.0.1:8080/api/ -e BACKEND_WS_URL=ws://127.0.0.1:19000/ws imy-frontend:0405

echo "部署完成"