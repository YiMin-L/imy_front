#!/bin/sh

# 替换nginx配置中的环境变量
envsubst '${BACKEND_API_URL} ${BACKEND_WS_URL}' < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf

# 启动nginx
exec nginx -g 'daemon off;'