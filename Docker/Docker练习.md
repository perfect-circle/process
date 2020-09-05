# Docker实战练习

## Docker安装并MySQL
```shell
# 具体需要什么版本可在Docker Hub上查找
docker pull mysql:5.7

# 运行Docker下的MySQL
docker run -d \
	-p 3307:3306\    # 把Docker中的MySQL端口映射到本机的3307端口
	--name db\
	-e MYSQL_ROOT_PASSWORD=123\    # 设置变量使MySQL 的root密码为123
	mysql:5.7
```

## Linux链接数据库
```shell
mysql -h47.223.44.123 -uroot -p123 -P3307    # -P输入服务器端口

```

## MaxOS链接MySQL
1. 下载mysql-connector-c
```shell
brew install mysql-connector-c
```

2. 设置环境变量
```shell
echo 'export PATH="/usr/local/opt/mysql-client/bin:$PATH"' >> ~/.zshrc
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
```

3. 更改mysql_config
```shell
vim /usr/local/Cellar/mysql-client/8.0.21/bin/mysql_config

原文件
# Create options
113行  libs="-L$pkglibdir"
114行  libs="$libs -l "
修改后
# Create options 
113行  libs="-L$pkglibdir"
114行  libs="$libs -lmysqlclient -lssl -lcrypto"

```

3. 下载SQLAlchemy和mysqlclient
```shell
pip install sqlalchemy mysqlclient
```

4. 链接数据库
```python
from sqlalchemy import create_engine
engine = create_engine('mysql://root:123@47.213.42.31/test')
engine.execute('select * from user').fetchall()
```
