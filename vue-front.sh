#!/bin/bash
WORK_PATH='/usr/projects/my-vue-project'
cd $WORK_PATH
echo "先清除老代码"
git reset --hard origin/main
git clean -f
echo "拉取最新代码"
git pull
echo "编译"
pnpm run build
echo "开始构建"
docker build -t my-vue-project:1.0.0 .
echo "停止旧容器并删除旧容器"
docker stop my-vue-project-container
docker rm my-vue-project-container
echo "启动新容器"
docker container run -p 80:80 --name my-vue-project-container -d my-vue-project:1.0.0
echo "清理悬空镜像"
docker rmi $(docker images -f "dangling=true" -q) || true