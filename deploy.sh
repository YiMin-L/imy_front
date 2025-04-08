#!/bin/bash

# 查看本地是否有 Nginx 镜像
NGINX_IMAGE=$(docker images | grep nginx | head -n 1 | awk '{print $1":"$2}')

if [ -z "$NGINX_IMAGE" ]; then
  echo "本地没有 Nginx 镜像，尝试从国内镜像源拉取..."
  docker pull nginx:alpine
  NGINX_IMAGE="nginx:alpine"
fi

# 使用找到的 Nginx 镜像构建应用
echo "使用镜像: $NGINX_IMAGE"
cat > Dockerfile.temp << EOF
FROM $NGINX_IMAGE
COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8000
CMD ["nginx", "-g", "daemon off;"]
EOF



# 构建 Docker 镜像
docker build -t imy-frontend:0405 --build-arg BACKEND_API_URL=http://127.0.0.1:8080 --build-arg BACKEND_WS_URL=ws://127.0.0.1:19000/ws -f Dockerfile .

# 停止并删除旧容器（如果存在）
docker stop imy-frontend 2>/dev/null || true
docker rm imy-frontend 2>/dev/null || true

# 运行新容器
docker run -d --name imy-frontend -p 8000:8000 -e BACKEND_API_URL=http://127.0.0.1:8080/api/ -e BACKEND_WS_URL=ws://127.0.0.1:19000/ws imy-frontend:0405

echo "部署完成"