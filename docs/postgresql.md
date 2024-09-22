---
outline: deep
---

# PostgreSQL

## 简介

[PostgreSQL](https://www.postgresql.org/) 是一个功能强大的开源对象关系数据库管理系统（ORDBMS）。

## 安装

在 [PostgreSQL Download](https://www.postgresql.org/download/) 页面可以找到不同 OS 的安装方式

例如 Linux Ubuntu 可以通过 apt 包管理器安装：

```bash
apt install postgresql        # 完整安装数据库（服务器）和客户端
apt install postgresql-client # 仅安装客户端 (libpq5 postgresql-client postgresql-client-common)
```

macOS 可以下载 [Postgres.app](https://postgresapp.com/downloads.html)，也可以通过 Homebrew 安装：

```bash
brew install postgresql
brew install postgresql@15
```


安装完毕后，系统会创建一个数据库超级用户 postgres，密码为空。
```shell
#  sudo -i -u postgres
```

这时使用以下命令进入 postgres，输出以下信息，说明安装成功：
```shell
~$ psql
psql (9.5.17)
Type "help" for help.

postgres=# 
```

输入以下命令退出 PostgreSQL 提示符：
```shell
\q
```

PostgreSQL 安装完成后默认是已经启动的，但是也可以通过下面的方式来手动启动服务。
```shell
sudo /etc/init.d/postgresql start   # 开启
sudo /etc/init.d/postgresql stop    # 关闭
sudo /etc/init.d/postgresql restart # 重启
```

## 配置

PostgreSQL 数据库安装完成后，再需要做一些配置，才可以正常访问。
PostgreSQL 的配置文件在 `/etc/postgresql/<version>/main` 下，例如 `/etc/postgresql/16/main`，其中包含：
- `postgresql.conf`：主要配置文件
- `pg_hba.conf`：控制用户的认证方式
- `pg_ident.conf`：控制用户的认证方式
- `pg_ctl.conf`：控制 PostgreSQL 服务的启动方式
- `pg_service.conf`：控制 PostgreSQL 服务的启动方式


### postgresql.conf 文件


`postgresql.conf` 包含了 PostgreSQL 服务器的配置信息，例如数据库的位置、端口号、最大连接数等。

```conf
#------------------------------------------------------------------------------
# FILE LOCATIONS
#------------------------------------------------------------------------------
data_directory = '/var/lib/postgresql/16/main'          # use data in another directory
hba_file = '/etc/postgresql/16/main/pg_hba.conf'        # host-based authentication file
ident_file = '/etc/postgresql/16/main/pg_ident.conf'    # ident configuration file
#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------
port = 5432                             # (change requires restart)
max_connections = 100                   # (change requires restart)
```

修改配置文件后，需要重启 PostgreSQL 服务，使配置生效。

```shell
/etc/init.d/postgresql restart
```


### pg_hba.conf 文件

`pg_hba.conf` (**h**ost-**b**ased **a**uthentication file) 是基于主机的认证文件，用于控制用户的认证方式，例如允许连接哪些主机，如何对客户端进行身份验证，可以使用哪些PostgreSQL用户名，可以访问哪些数据库。

该文件记录采用以下形式之一：
```conf
# TYPE  DATABASE  USER  [ADDRESS]  METHOD  [OPTIONS]
```

- `TYPE` 是连接类型：

| TYPE         | explain                                    | 说明                          |
| ------------ | ------------------------------------------ | ----------------------------- |
| local        | Unix-domain socket                         | Unix域套接字                  |
| host         | TCP/IP socket (encrypted or not)           | TCP/IP 套接字（加密或未加密） |
| hostssl      | TCP/IP socket that is SSL-encrypted        | SSL加密的TCP/IP套接字         |
| hostnossl    | TCP/IP socket that is not SSL-encrypted    | 未加密的TCP/IP套接字          |
| hostgssenc   | TCP/IP socket that is GSSAPI-encrypted     | GSSAPI加密的TCP/IP套接字      |
| hostnogssenc | TCP/IP socket that is not GSSAPI-encrypted | 未加密的TCP/IP套接字          |

`DATABASE` 是数据库名称，可以是 `all` 表示所有数据库、`sameuser` 表示与用户名同名的数据库、`samegroup` 表示与用户组同名的数据库

- `USER` 是用户名

- `ADDRESS` 是客户端的 IP 地址，对于 `local` 类型的连接，`ADDRESS` 可以省略

- `METHOD` 是认证方式：

| METHOD        | 说明                                       |
| ------------- | ------------------------------------------ |
| trust         | 无条件信任                                 |
| reject        | 拒绝连接                                   |
| md5           | 使用 MD5 加密认证                          |
| scram-sha-256 | 使用 SCRAM-SHA-256 加密认证                |
| password      | 使用**明文**密码认证                       |
| peer          | 使用客户端的操作系统用户名作为数据库用户名 |

> peer 认证方式是指，不需要密码验证可以进入，但是必须是操作系统的用户，且数据库中有对应的用户。


- `OPTIONS` 是其他选项

默认的已经有一些记录了：
```conf
# TYPE  DATABASE        USER            ADDRESS                 METHOD
# Database administrative login by Unix domain socket
local   all             postgres                                peer
# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            scram-sha-256
# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
```

该记录表示，允许本地 postgres 和全部用户使用 peer 认证方式连接数据库
```shell
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                peer
local   all             all                                     peer
local   all             all                                     ident map=rootmap
```

说明内置了一个超级用户 postgres，用于本地连接数据库。
```shell
cat /etc/passwd | grep postgres
# postgres:x:102:104:PostgreSQL administrator,,,:/var/lib/postgresql:/bin/bash
cat /etc/shadow | grep postgres
# postgres:!:19987::::::
cat /etc/group | grep postgres
# postgres:x:104:
```

### pg_ident.conf

该文件用于控制用户的认证方式，例如允许连接哪些主机，如何对客户端进行身份验证，可以使用哪些 PostgreSQL 用户名，可以访问哪些数据库。


```conf
# MAPNAME       SYSTEM-USERNAME         PG-USERNAME
```



该文件需要配合 `pg_hba.conf` 使用，`pg_hba.conf` 中的 `METHOD` 为 `ident` 时，会使用 `pg_ident.conf` 文件中的规则进行认证。

例如，`pg_hba.conf` 文件中的记录：
```conf
# pg_hba.conf 文件
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     ident map=map_root

# pg_ident.conf 文件
# MAPNAME       SYSTEM-USERNAME         PG-USERNAME
 map_root                  root              pgroot
```

表示，当用户 root 通过 peer 认证方式连接数据库时，会使用 pgroot 用户进行认证。

### 认证方式选择

#### 添加用户映射

PostgreSQL登陆默认是peer，不需要验证用户密码即可进入postgresql相关数据库，但前提是必须切换用户登陆。类似于最开始执行的 `su postgres; psql` 一样。

#### 密码认证







## 基本操作
### 连接数据库

连接数据库
```shell
psql -h <dbserver_IP> -p<dbserver_port> -d <database_Name> -U <db user>
psql -h postgres_db -U postgres -d postgres
# -h, --host=HOSTNAME      database server host or socket directory (default: "local socket")
# -U, --username=USERNAME   database user name
# -d, --dbname=DBNAME       database name to connect to (default: same as username)
```

连接数据库后，可以使用以下命令查看当前数据库的信息：
```shell
\conninfo
```

### 基本命令

```shell
\q              # 退出
\l              # 列出所有数据库
\c <db_name>    # 连接到指定数据库
\dt             # 列出当前数据库的所有表
\d <table_name> # 查看表的结构
\d              # 查看当前数据库的所有表
```

### 创建数据库

```shell
CREATE DATABASE <db_name>;
```
```shell
CREATE DATABASE test;   # 创建一个名为 test 的数据库
\l test               # 查看 test 数据库的信息
#     Name    |  Owner   | Encoding | Locale Provider |  Collate   |   Ctype    | ICU Locale | ICU Rules |   Access privileges   
# ------------+----------+----------+-----------------+------------+------------+------------+-----------+-----------------------
#  test       | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | 
```

