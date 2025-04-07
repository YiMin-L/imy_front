#!/bin/bash

# 设置服务器信息
#SERVER_IP="149.88.87.195"
SERVER_IP="110.41.140.29"
SERVER_USER="root"
SERVER_PATH="/root/im/imy_front"

# 创建远程目录（如果不存在）
ssh ${SERVER_USER}@${SERVER_IP} "mkdir -p ${SERVER_PATH}"

# 上传 dist 目录、Dockerfile 和 nginx.conf
rsync -avz --delete dist/ ${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}/dist/
scp Dockerfile nginx.conf deploy.sh ${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}/

# 远程执行部署脚本
ssh ${SERVER_USER}@${SERVER_IP} "cd ${SERVER_PATH} && chmod +x deploy.sh && ./deploy.sh"

echo "上传并部署完成"