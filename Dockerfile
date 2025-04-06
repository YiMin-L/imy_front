# 构建阶段
FROM node:18.14.2-alpine as build-stage

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json (如果存在)
COPY package*.json ./

# 安装依赖（包括开发依赖）
RUN npm config set registry https://registry.npmmirror.com && \
    npm install

# 复制项目文件
COPY . .

# 设置环境变量
ARG BACKEND_API_URL
ARG BACKEND_WS_URL
ENV VUE_APP_API_BASE_URL=${BACKEND_API_URL:-http://localhost:8080}
ENV VUE_APP_WEB_SOCKET_URL=${BACKEND_WS_URL:-ws://localhost:19000/ws}
ENV NODE_OPTIONS=--openssl-legacy-provider

# 构建应用
RUN npm run build

# 生产阶段
FROM nginx:alpine-perl as production-stage

# 复制构建结果到 Nginx 服务目录
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 复制自定义 Nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 8000

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]