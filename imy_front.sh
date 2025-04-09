#!/bin/bash

export NODE_OPTIONS=--openssl-legacy-provider
npm run build

# 设置服务器信息
#SERVER_IP="149.88.87.195"
SERVER_IP="110.41.140.29"
SERVER_USER="root"
SERVER_PATH="/root/im/imy_front"

# 启动 SSH Agent 并添加密钥
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_imy_front

# 创建远程目录（如果不存在）
ssh -o ControlMaster=auto -o ControlPath=~/.ssh/control-%r@%h:%p -o ControlPersist=yes ${SERVER_USER}@${SERVER_IP} "mkdir -p ${SERVER_PATH}"

# 上传 dist 目录、Dockerfile 和 nginx.conf
rsync -avz --delete -e "ssh -o ControlMaster=auto -o ControlPath=~/.ssh/control-%r@%h:%p -o ControlPersist=yes" dist/ ${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}/dist/
scp -o ControlMaster=auto -o ControlPath=~/.ssh/control-%r@%h:%p -o ControlPersist=yes Dockerfile nginx.conf deploy.sh ${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}/

# 远程执行部署脚本
ssh -o ControlMaster=auto -o ControlPath=~/.ssh/control-%r@%h:%p -o ControlPersist=yes ${SERVER_USER}@${SERVER_IP} "cd ${SERVER_PATH} && chmod +x deploy.sh && ./deploy.sh"

# 关闭 SSH 连接复用
ssh -O exit -o ControlPath=~/.ssh/control-%r@%h:%p ${SERVER_USER}@${SERVER_IP}

echo "上传并部署完成"