#!/bin/bash
WORK_PATH='/usr/projects/my-nest-project'
cd $WORK_PATH
echo "先清除老代码"
git reset --hard origin/main
git clean -f
echo "拉取最新代码"
git pull
echo "开始构建"
docker build -t my-nest-project:1.0.0 .
echo "停止旧容器并删除旧容器"
docker stop my-nest-project-container
docker rm my-nest-project-container
echo "启动新容器"
docker container run -p 3000:3000 --name my-nest-project-container -d my-nest-project:1.0.0