
前端代码来源于：https://github.com/gzydong/LumenIM

### 功能模块
- 支持私聊及群聊
- 支持多种聊天消息类型 例如:文本消息、代码块、群投票、图片及其它类型文件，并支持文件下载
- 支持聊天消息撤回、删除(批量删除)、转发消息(逐条转发、合并转发)
- 支持编写个人笔记


### 项目安装(部署)
###### 设置 npm 镜像源
```language
npm config set registry https://registry.npmmirror.com
```

###### 下载安装
```bash
## 安装项目依赖扩展组件
npm install

# 启动本地开发环境
npm run serve

# On Unix-like (Linux, macOS, Git bash, etc.):
export NODE_OPTIONS=--openssl-legacy-provider

# win
set NODE_OPTIONS=--openssl-legacy-providerOn 

PowerShell:
$env:NODE_OPTIONS = "--openssl-legacy-provider"



## 生产环境构建项目
npm run build

## 生产环境构建项目并查看构建报告
npm run build --report
```

###### 修改 .env 配置信息

```env

```

###### 关于 Nginx 的一些配置
```nginx
server {
    listen       80;
    server_name  www.yourdomain.com;

    root /project-path/dist;
    index  index.html;

    ## 解决 VueRouter History 模式下 页面刷新404问题
    location / {
      try_files $uri $uri/ /index.html;
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|flv|ico)$ {
        expires 7d;
    }

    location ~ .*\.(js|css)?$ {
        expires 7d;
    }
}
```



