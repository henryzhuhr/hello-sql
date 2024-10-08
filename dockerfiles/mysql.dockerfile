# 使用官方 mysql 镜像
FROM mysql:lts

# 环境变量来设置 mysql 的默认用户和数据库
ENV MYSQL_USER=mysql
ENV MYSQL_ROOT_PASSWORD=mysecretpassword
ENV MYSQL_DATABASE=mydb
ENV MYSQL_PASSWORD=mysecretpassword

# # 设置时区
# RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
# # 设置语言
# RUN localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8
# ENV LANG=zh_CN.UTF-8

# 修改日期格式
# RUN sed -i "s/datestyle = 'iso, mdy'/datestyle = 'iso, dmy'/g" /var/lib/postgresql/data/postgresql.conf
# 修改时区 timezone = 'Etc/UTC'
# RUN sed -i "s/timezone = 'Etc\/UTC'/timezone = 'Asia\/Shanghai'/g" /var/lib/postgresql/data/postgresql.conf
# log_timezone = 'Etc/UTC'
# RUN sed -i "s/log_timezone = 'Etc\/UTC'/log_timezone = 'Asia\/Shanghai'/g" /var/lib/postgresql/data/postgresql.conf

# 创建 init.sql 文件，用于初始化数据库
# COPY ./sql/mysql/*.sql /docker-entrypoint-initdb.d
COPY ./sql/mysql/init.sql /docker-entrypoint-initdb.d

# COPY ./config/postgresql.conf /etc/postgresql/postgresql.conf


