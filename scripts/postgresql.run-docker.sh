# ====================================
#   docker build
# ====================================
TARGET=postgresql
TAG=latest  # $(date +%Y-%m%d-%H%M%S)
IMAGE_TAG="ubuntu-$TARGET:$TAG"
DOCKERFILE="dockerfiles/Dockerfile"
# 定义构建参数（根据需要取消注释）
buildArgs=(
    # "--no-cache" # 不使用缓存
    # "--progress" "plain" # 显示构建进度
    # "--platform" "linux/amd64" # 跨平台构建 x86_64 -- Multi-platform builds: https://docs.docker.com/build/building/multi-platform/
)
docker build . -t $IMAGE_TAG -f $DOCKERFILE ${buildArgs[@]}

# ====================================
#   docker run
# ====================================
USER_NAME=root
WORKDIR=/root/$(basename $PWD)
# 定义运行参数（根据需要取消注释） 参数和值直接不能有空格，否则会被解析为多个参数
runArgs=(
    "-i"    # 交互式：即使没有附加，也保持STDIN打开
    "-t"    # 分配一个伪终端
    "--rm"  # 退出时删除容器，与 -d 互斥
    "-v" "${PWD}:$WORKDIR" # 挂载当前目录
    # "-w" "$WORKDIR"        # 指定工作目录
    "-w" "/etc/postgresql/16/main"        # 指定工作目录
    "-u" "$USER_NAME"      # 指定用户 (default:root)
    "-p" "5432:5432"       # 端口映射 (postgreSQL)
)
docker run ${runArgs[@]} --rm $IMAGE_TAG /bin/bash -l