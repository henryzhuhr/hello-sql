-- 设置时区
SET TIME ZONE 'Asia/Shanghai';
-- 设置语言
SET lc_messages = 'zh_CN.UTF-8';
-- 设置编码 
SET client_encoding = 'UTF8';
-- 设置日期格式

--  但是通过这种方式设置时区在你退出psql终端后，再次进入此psql中断后就会发现又恢复到原来的时区了，


-- 查看当前时间
SELECT now();
-- 查看当前时区
SHOW TIME ZONE;


-- 切换数据库（PostgreSQL 不支持切换数据库，需要在连接时指定数据库）
-- 创建扩展，如果尚未创建
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 用于生成 UUID gen_random_uuid()
-- 创建 users 表 
-- 在 PostgreSQL 中，user 是一个保留关键字，用于表示当前数据库用户。因此，直接使用 user 作为表名会导致语法错误
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users') THEN
        -- 如果表不存在，则创建表
        CREATE TABLE users (
            id SERIAL PRIMARY KEY, -- 主键（在 PostgreSQL 中，SERIAL 已经隐含了 INCREMENT BY 1 的行为，所以不需要显式指定。）
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 创建时间
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 更新时间
            deleted_at TIMESTAMP DEFAULT NULL, -- 删除时间 CN +8 时区
            uuid UUID DEFAULT gen_random_uuid() UNIQUE, -- UUID 字段
            username VARCHAR(64) NOT NULL UNIQUE, -- 用户名
            email VARCHAR(64) DEFAULT '' -- 邮箱
        );
    END IF;
END $$;

-- 添加一个字段 uuid 到 users 表，可能已经存在，也可能不存在
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'users'
          AND column_name = 'uuid'
    ) THEN
        -- 1. 添加允许 NULL 值的列
        ALTER TABLE users ADD COLUMN uuid UUID;
        -- 2. 更新现有数据，为所有现有行设置默认 UUID
        UPDATE users SET uuid = gen_random_uuid() WHERE uuid IS NULL;
        -- 3. 添加 NOT NULL 约束
        ALTER TABLE users ALTER COLUMN uuid SET NOT NULL;

    END IF;
END $$;



-- 添加一个字段 password 到 users 表  NOT NULL：
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'users'
          AND column_name = 'password'
    ) THEN
        -- 1. 添加允许 NULL 值的列
        ALTER TABLE users ADD COLUMN password VARCHAR(64);
        -- 2. 更新现有数据，为所有现有行设置默认密码
        UPDATE users SET password = 'default_password' WHERE password IS NULL;
        -- 3. 添加 NOT NULL 约束
        ALTER TABLE users ALTER COLUMN password SET NOT NULL;

    END IF;
END $$;


-- 删除字段 password
-- ALTER TABLE users DROP COLUMN password;

INSERT INTO users (created_at, updated_at, username, email, password) VALUES (NOW (), NOW (), 'admin', '', 'admin');
INSERT INTO users (created_at, updated_at, username, email, password) VALUES (NOW (), NOW (), 'user1', 'user1@gmail.com', 'user1passwd');
INSERT INTO users (created_at, updated_at, username, email, password) VALUES (NOW (), NOW (), 'user2', 'user2@gmail.com', 'user2passwd');

select * from users;