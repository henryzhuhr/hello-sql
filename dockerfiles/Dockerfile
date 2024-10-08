FROM ubuntu:latest

ARG MIRRORS_URL="mirrors.ustc.edu.cn"
ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ${HOME}/.bashrc
RUN sed -i -e "s#//.*archive.ubuntu.com#//${MIRRORS_URL}#g" -e "s#//ports.ubuntu.com#//${MIRRORS_URL}#g" /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    ca-certificates locales \
    git \
    vim \
    postgresql-client \
    mysql-client \
    golang

# 系统时间错误导致: `tls: failed to verify certificate: x509: certificate signed by unknown authority`
# 修改时区 (date -R 检查当前时间)
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 设置语言 (locale -a 查看支持的语言)
# 如果没有 zh_CN.UTF-8 执行 locale-gen zh_CN.UTF-8 && dpkg-reconfigure locales && locale -a
RUN localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8

RUN set -x && \
    go env -w GO111MODULE=on && \
    go env -w GOPROXY=https://goproxy.cn,direct && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/cweill/gotests/...@latest && \
    go install github.com/fatih/gomodifytags@latest && \
    go install github.com/josharian/impl@latest && \
    go install github.com/haya14busa/goplay/cmd/goplay@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
