#!/bin/bash

# 定义环境变量
MYSQL_ROOT_PASSWORD="mysecretpassword"
MYSQL_DATABASE="mydb"
MYSQL_USER="mysql"
MYSQL_PASSWORD="mysecretpassword"

# 创建自定义网络（如果还没有创建）
docker network create hello-sql-network || true

# 运行MySQL容器
docker run -d \
  --name mysql_db \
  --restart always \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -e MYSQL_DATABASE=$MYSQL_DATABASE \
  -e MYSQL_USER=$MYSQL_USER \
  -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
  --network hello-sql-network \
  -v mysql_data:/var/lib/mysql \
  mysql:lts