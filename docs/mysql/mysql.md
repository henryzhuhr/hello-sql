---
outline: deep
---

# MySQL


## MySQL


## MySQL 数据类型

MySQL 数据类型可以分为**数值类型**、**日期和时间类型**、**字符串类型**、**二进制数据类型**等传统类型，以及新增的**JSON类型**、**空间数据类型**等。

### 数值类型

数值类型又可以分为**整数类型**、**浮点数类型**、**定点数类型**、**BIT类型**等。

| 类型             | 字节数 | 范围（有符号）                    | 范围（无符号）       |
| ---------------- | ------ | --------------------------------- | -------------------- |
| TINYINT          | 1      | -128~127($2^{-7}$~$2^{7}-1$)      | 0~255($2^{8}-1$)     |
| SMALLINT         | 2      | -32768~32767($2^{15}$~$2^{15}-1$) | 0~65535($2^{16}-1$)  |
| MEDIUMINT        | 3      | $2^{23}$~$2^{23}-1$               | $2^{24}-1$           |
| INT              | 4      | $2^{31}$~$2^{31}-1$               | $2^{32}-1$           |
| BIGINT           | 8      | $2^{63}$~$2^{63}-1$               | $2^{64}-1$           |
| DECIMAL([M[,D]]) | M+2    | 存储M位整数和D位小数              | 存储M位整数和D位小数 |
| FLOAT            | 4      | 单精度浮点数                      | 单精度浮点数         |
| DOUBLE           | 8      | 双精度浮点数                      | 双精度浮点数         |
| BIT              | M/8    | 存储M位二进制数                   | 存储M位二进制数      |

> - 数值类型可以添加 `[(M)]` 表示可选的长度参数，例如 `INT(2)`，表示整数的显示宽度为2，不影响存储大小。例如在 `ZEROFILL` 模式下，会用0填充，当存储 1 时，显示为 001。
> - 但是 `DECIMAL` 类型的 `M` 表示整数部分和小数部分的总长度，`D` 表示小数部分的长度，例如 `DECIMAL(5,2)` 表示总长度为5，小数部分长度为2。

**整数类型**

整数类型包括 `TINYINT`、`SMALLINT`、`MEDIUMINT`、`INT`、`BIGINT`，分别对应1、2、3、4、8个字节，存储范围为 $-2^{n-1}$~$2^{n-1}-1$（有符号）或 $0$~$2^n-1$（无符号）(n=8,16,32,64)。

无符号采用关键字 `UNSIGNED`，例如 `INT UNSIGNED`，不允许存储负数，但是可以存储的正数范围是原来的两倍。


对于整数类型：
- 可以指定 `ZEROFILL`，表示用0填充，例如 `INT ZEROFILL`
- 可以指定 `AUTO_INCREMENT`，表示自动增长，例如 `INT AUTO_INCREMENT`/`INT UNSIGNED AUTO_INCREMENT`


**实数类型**：**浮点数类型**和**定点数类型**

浮点数类型包括 `FLOAT` 和 `DOUBLE`，是一种近似值类型，适用于科学计算和工程计算。
定点数类型包括 `DECIMAL`，是一种精确值类型，适用于财务计算和货币计算。

- 浮点数可以使用 `UNSIGNED` ，与整数一样，这会让浮点数变成全部是正数，不支持负数。
- 浮点数可以使用 `AUTO_INCRMENT`,这会让浮点数的表现与整数一样了。



### 字符串类型

字符串类型可以分为**非二进制字符串类型**和**二进制字符串类型**。
- **非二进制字符串类型**包括 `CHAR`、`VARCHAR`、`TINYTEXT`、`TEXT`、`MEDIUMTEXT`、`LONGTEXT`、`ENUM`、`SET` 等。

- **二进制字符串类型**包括 `TINYBLOB`、`BLOB`、`MEDIUMBLOB`、`LONGBLOB` 等。


**非二进制字符串类型**
| 类型       | 描述                                                           |
| ---------- | -------------------------------------------------------------- |
| CHAR(N)    | 定长字符串，最大长度为N，不足N的会用空格填充。                 |
| VARCHAR(N) | 变长字符串，最大长度为N，不占用空间存储长度，最大长度为65535。 |
| TINYTEXT   | 最大长度为255。                                                |
| TEXT       | 最大长度为65535。                                              |
| MEDIUMTEXT | 最大长度为16777215。                                           |
| LONGTEXT   | 最大长度为4294967295。                                         |

**二进制字符串类型** (BLOB)
| 类型         | 描述                                                           |
| ------------ | -------------------------------------------------------------- |
| BINARY(N)    | 定长字符串，最大长度为N，不足N的会用0填充。                    |
| VARBINARY(N) | 变长字符串，最大长度为N，不占用空间存储长度，最大长度为65535。 |
| TINYBLOB     | 最大长度为255。                                                |
| BLOB         | 最大长度为65535。                                              |
| MEDIUMBLOB   | 最大长度为16777215。                                           |
| LONGBLOB     | 最大长度为4294967295。                                         |

还有一些特殊的字符串类型，如 `SET` 和 `ENUM`。
| 类型                    | 描述                                               |
| ----------------------- | -------------------------------------------------- |
| SET('val1','val2',...)  | 一个字符串对象，可以包含零个或多个由逗号分隔的值。 |
| ENUM('val1','val2',...) | 一个字符串对象，可以包含一个由逗号分隔的值列表。   |


### 日期和时间类型

日期和时间类型包括 `DATE`、`TIME`、`DATETIME`、`TIMESTAMP`、`YEAR` 等。

| 类型      | 字节数 | 范围                                        | 格式                |
| --------- | ------ | ------------------------------------------- | ------------------- |
| YEAR      | 1      | 1901~2155                                   | YYYY                |
| DATE      | 3      | '1000-01-01'~'9999-12-31'                   | YYYY-MM-DD          |
| TIME      | 3      | '-838:59:59'~'838:59:59'                    | HH:MM:SS            |
| DATETIME  | 8      | '1000-01-01 00:00:00'~'9999-12-31 23:59:59' | YYYY-MM-DD HH:MM:SS |
| TIMESTAMP | 4      | '1970-01-01 00:00:01'~'2038-01-19 03:14:07' | YYYY-MM-DD HH:MM:SS |

**DATE**：`DATE` 为日期格式，默认零值为'0000-00-00'

**TIME** ：`TIME` 不是表示一个时间点，而是表示一个时间段，表示两个事件之间的时间，因此可以为负数。默认零值为'00:00:00'。当写入 11:30

**DATETIME** 是日期**DATE**和时间**TIME** 的组合

**TIMESTAMP** 保存日期与时间，默认为 UTC（世界标准时间）格式存储，占用4个字节，当查询数据的时候，会自动转换为当前时区的时间。

### JSON类型

MySQL 5.7.8 版本开始支持 JSON 数据类型，可以存储 JSON 数据。JSON 数据类型存储长度和 LONGTEXT 类型相同，但是不能超过系统变量 `max_allowed_packet` 的限制。

```sql
CREATE TABLE t1 (
    jdoc JSON 
    jdata JSON NOT NULL 
);
```

> json 类型的数据可以存储任意的json数据，但是不支持索引，不支持全文搜索，不支持外键约束，不支持自动增长，不支持默认值，不支持唯一约束，不支持主键约束。


插入数据时，可以使用 `JSON_OBJECT`、`JSON_ARRAY`、`JSON_OBJECTAGG`、`JSON_ARRAYAGG` 等函数来生成 JSON 数据。

```sql
INSERT INTO t1 VALUES ('{'key1': 'value1', 'key2': 'value2'}');
INSERT INTO t1 VALUES (JSON_OBJECT('key1', 'value1', 'key2', 'value2'));
INSERT INTO t1 VALUES (JSON_ARRAY('value1', 'value2'));
```

### 空间数据类型

空间数据类型一般是用来存储地理信息系统（GIS）数据，包括点、线、面等。

### 数据类型的选择原则

- 避免使用 NULL

NULL 会占用额外的存储空间，在索引处理方面复杂，在查询时需要特殊处理。

## SQL Basics

SQL是一种用于与数据库交互的语言。它用于执行诸如查询数据、更新数据和从数据库中删除数据等任务。



## SQL 语法
<!-- ### SQL Syntax -->

SQL 的基本语法如下：

```sql
CREATE DATABASE dbname;  -- (mysql命令) 创建数据库
USE dbname;  -- (mysql命令) 使用数据库
CREATE TABLE table_name (column1 datatype, column2 datatype, column3 datatype, ...);  -- 创建表
SELECT column1, column2, ... FROM table_name;  -- 查询数据
```

## SQL 语法

SQL Syntax 可以分为以下几种类型：

- **DDL（数据定义语言）**：`CREATE`, `DROP`, `ALTER`, `TRUNCATE`，对表结构进行增删改
- **DML（数据操作语言）**：`INSERT`, `UPDATE`, `DELETE`, `CALL`, 对表当中的数据进行增删改
- **DQL（数据查询语言）**：查询语句 `SELECT(WHERER)`
- **TCL（事务控制语言）**：`COMMIT` 提交事务，`ROLLBACK` 回滚事务（TCL中的T是 Transaction）
- **DCL（数据控制语言）**：`GRANT` 授权、`REVOKE` 撤销权限等


### 数据定义


#### 创建数据库或数据表

创建数据库使用 `CREATE DATABASE` 语句，

```sql
CREATE DATABASE database_name;
USE database_name;
```

创建数据表使用 `CREATE TABLE` 语句，并定义字段名和数据类型。

```sql
CREATE TABLE `table_name` (
    `column1` datatype,
    `column2` datatype,
    ...
);
```

创建表时，可以指定列的名称、数据类型和约束。例如：

```sql
CREATE TABLE users (
    id INT,
    name VARCHAR(255),
    email VARCHAR(255),
    age INT
);
```

### 修改数据表 ALTER

`ALTER TABLE` 语句用于添加、删除或修改表的列，分别使用 `ADD`、`DROP`、`MODIFY` 关键字。


> 用 `tn` 表示表名，`cn` 表示列名，`dt` 表示数据类型，`dv` 表示默认值。
添加字段
```sql
ALTER TABLE `tn` ADD `cn` datatype;
```

删除字段
```sql
ALTER TABLE `tn` DROP COLUMN `cn`;
```

修改字段数据类型
```sql
ALTER TABLE `tn` MODIFY COLUMN `cn` datatype;
```

修改字段类型和约束
```sql
ALTER TABLE `tn` MODIFY COLUMN `cn` datatype DEFAULT 'default_value';
ALTER TABLE `tn` MODIFY COLUMN `cn` datatype NOT NULL;
```
> - 约束可以是非空 `NOT NULL`、默认值 `DEFAULT`、唯一 `UNIQUE`、主键约束 `PRIMARY KEY`、外键约束 `FOREIGN KEY` 等。
> - 主键约束 `PRIMARY KEY`：唯一标识表中的每一行，主键必顺是唯一的，且不允许有 NULL 值。
> - 外键约束 `FOREIGN KEY`：用于关联两个表的关系，保证数据的一致性，外键约束的列必须是另一个表的主键。

重命名字段
```sql
ALTER TABLE `tn` CHANGE `old_cn` `new_cn` datatype;
-- (MySQL 8.0.13+)
ALTER TABLE `tn` RENAME `old_cn` to `new_cn`;
```

### 数据的增删改查

数据的增删改查操作分别对应 `INSERT`、`DELETE`、`UPDATE` 和 `SELECT` 语句。

#### INSERT 语句

插入数据可以使用 `INSERT INTO` 语句，指定表名和字段名，然后指定要插入的值。
```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

如果要插入所有字段的值，可以省略字段名。
```sql
INSERT INTO table_name VALUES (value1, value2, ...);
```

插入多组数据时，可以使用多个 `VALUES` 子句。
```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...),
       (value1, value2, ...),
       ...;
```

#### SELECT 语句和 WHERE 子句

SELECT 语句用于查询数据，可以指定要查询的字段名，也可以使用 `*` 表示所有字段。`WHERE` 子句用于过滤数据，只返回满足条件的数据。
```sql
SELECT column1, column2, ... 
FROM table_name
WHERE condition;
```

#### UPDATE 语句

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

#### DELETE 语句

一般要和 `WHERE` 子句一起使用，否则会删除所有数据。
```sql
DELETE FROM table_name
WHERE condition;
```

#### WHERE 子句

WHERE 子句用于过滤数据，只返回满足条件的数据。可以使用 `AND`、`OR`、`NOT` 等逻辑运算符，也可以使用 `IN`、`BETWEEN`、`LIKE` 等操作符。



优先级上：`NOT` > `AND` > `OR`，可以使用括号来改变优先级。



## 参考和资料

- [MySQL语法总结-基础语法 - 辰智的文章 - 知乎](https://zhuanlan.zhihu.com/p/63111767)
- [🔥MySQL一万字深度总结，基础+进阶(一)，建议收藏。✨💖-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1856648)               