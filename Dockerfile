# 直接使用 nginx 镜像
FROM nginx:alpine

# 复制本地构建结果到 Nginx 服务目录
COPY dist/ /usr/share/nginx/html/

# 复制自定义 Nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 8000

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]