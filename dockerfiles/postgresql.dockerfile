# 使用官方 PostgreSQL 镜像
FROM postgres:latest

# 环境变量来设置 Postgres 的默认用户和数据库
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=mysecretpassword
ENV POSTGRES_DB=mydatabase

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
# 设置语言
RUN localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8

# 修改日期格式
# RUN sed -i "s/datestyle = 'iso, mdy'/datestyle = 'iso, dmy'/g" /var/lib/postgresql/data/postgresql.conf
# 修改时区 timezone = 'Etc/UTC'
# RUN sed -i "s/timezone = 'Etc\/UTC'/timezone = 'Asia\/Shanghai'/g" /var/lib/postgresql/data/postgresql.conf
# log_timezone = 'Etc/UTC'
# RUN sed -i "s/log_timezone = 'Etc\/UTC'/log_timezone = 'Asia\/Shanghai'/g" /var/lib/postgresql/data/postgresql.conf

# 创建 init.sql 文件，用于初始化数据库
COPY ./sql/postgresql/init.sql /docker-entrypoint-initdb.d/

COPY ./config/postgresql.conf /etc/postgresql/postgresql.conf

# 暴露 PostgreSQL 的默认端口
# EXPOSE 5432

# 将容器启动命令保留为官方的默认命令
CMD ["postgres"]


