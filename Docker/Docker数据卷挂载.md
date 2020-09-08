# Docker数据卷挂载

## 什么是容器数据卷

1. Docker理念：将环境和应用打包成一个镜像
2. 如果数据在容器中，容器删除，数据就会丢失。
3. 容器卷技术，把容器和数据分开，数据存储在本地
4. 将我们容器没的目录，挂载到Linux本机上
5. 容器间数据共享

![Docker数据卷挂载](image/09_8_1.png)

## 数据卷挂载命令 -v

```shell
docker run -d -v主机目录:容器目录
```

## 挂载并运行MySQL

```shell
[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker run -d \  # 后台运行
> -p 3344:3306 \   # 主机3344端口映射到容器3306端口
> -v /home/mysql/conf:/etc/mysql/conf.d \    # 挂载MySQL配置目录
> -v /home/mysql/data:/var/lib/mysql \    # 挂载MySQL数据目录
> -e MYSQL_ROOT_PASSWORD=123456 \    # 设置MySQLroot密码
> --name mysql01 \   # 取名mysql01
> mysql:5.7    # 启动的镜像
```

## 测试

### 数据卷在本地情况

```shell
[root@iZm5e8ucr8vsejbzgby5olZ home]# cd mysql/
[root@iZm5e8ucr8vsejbzgby5olZ mysql]# ls
conf  data
```

**由此可见容器里的数据已经在主机上了，删除容器数据不会丢失，实现量数据持久化，但是数据量翻倍。**

### 连接数据库

```shell
sudo mysql -h43.32.111.111 -ppassword -P主机port
```

## 具名挂载和匿名挂载

```shell
docker run -d -v 容器内路径    # 匿名挂载
docker run -d -v Volume名:容器内路径    # 具名挂载
docker run -d -v 主机目录:容器目录 	# 指定目录挂载

# docker volume ls 查看挂载
[root@iZm5e8ucr8vsejbzgby5olZ simpledu]# docker volume ls
DRIVER              VOLUME NAME
local               5f6d3f6255485e9229e338b7da4676ec9cfd37a2fd1b7a3b78bcd479b08d63f5 # 匿名挂载
local               d195fb8290ac7bedf0f90cf619f6d4cf3802480430b965fb358ad2bb59e271c5
local               mysql_conf  # 具名挂载
local               mysql_data

# 查看挂载卷的具体信息
root@iZm5e8ucr8vsejbzgby5olZ simpledu]# docker volume inspect mysql_conf
[
    {
        "CreatedAt": "2020-09-08T11:09:19+08:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/mysql_conf/_data",
        "Name": "mysql_conf",
        "Options": null,
        "Scope": "local"
    }
]
```

**可以看到没有指定目录挂载，所有的卷都会在/var/lib/docker/volumes下**

### 挂载权限设置

```shell
# ro 	readonly # 只读
# rw    readwrite # 读写
docker run -d -P --name nginx 02 -v mysql_conf:/etc/mysql/conf.d:rw mysql:5.7 # 容器可读可写
docker run -d -P --name nginx 02 -v mysql_conf:/etc/mysql/conf.d:ro mysql:5.7 # 容器只可读
```

## 初识Dockerfile

[dockerfile]

```
FROM centos

VOLUME ["volume01","volume02"]

CMD echo "--------end--------"

CMD /bin/bash
```

```shell
# 运行dockerfile

root@iZm5e8ucr8vsejbzgby5olZ ~]# docker build -f dockerfile -t huo_centos:1.0 .
Sending build context to Docker daemon  292.4kB
Step 1/4 : FROM centos
 ---> 0d120b6ccaa8
Step 2/4 : VOLUME ["volume01","volume02"]
 ---> Running in 5c06006308c6
Removing intermediate container 5c06006308c6
 ---> e8f9474a8713
Step 3/4 : CMD echo "--------end--------"
 ---> Running in 453c65f76ea6
Removing intermediate container 453c65f76ea6
 ---> 74a10c7a3581
Step 4/4 : CMD /bin/bash
 ---> Running in 9f4e941bd841
Removing intermediate container 9f4e941bd841
 ---> 26e3928433bd
Successfully built 26e3928433bd
Successfully tagged huo_centos:1.0

# 查看镜像
root@iZm5e8ucr8vsejbzgby5olZ ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
huo_centos          1.0                 26e3928433bd        About a minute ago   215MB  # 刚刚创建的镜像
mysql               5.7                 d589ea3123e0        3 days ago           448MB
redis               latest              41de2cc0b30e        6 days ago           104MB
nginx               latest              4bb46517cac3        3 weeks ago          133MB

# 启动自己的镜像
root@iZm5e8ucr8vsejbzgby5olZ ~]# docker run -it 26e3928433bd /bin/bash
[root@902ec5b62311 /]# ls
bin  etc   lib	  lost+found  mnt  proc  run   srv  tmp  var	   volume02
dev  home  lib64  media       opt  root  sbin  sys  usr  volume01

# 查看容器信息Docker inspect

```shell
[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker inspect a627387580e3
"Mounts": [
            {
                "Type": "volume",
                "Name": "8396371807aab9f4425cd7399db0eb938ca76fe7a9ff391f4e166476d8bd152b",
                "Source": "/var/lib/docker/volumes/8396371807aab9f4425cd7399db0eb938ca76fe7a9ff391f4e166476d8bd152b/_data",
                "Destination": "volume01",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            },
            {


root@iZm5e8ucr8vsejbzgby5olZ ~]# cd /var/lib/docker/volumes/8396371807aab9f4425cd7399db0eb938ca76fe7a9ff391f4e166476d8bd152b/_data
[root@iZm5e8ucr8vsejbzgby5olZ _data]# ls
test.txt
```

## 容器内数据同步

![容器间数据共享](image/09_8_2.png) 

```shell
root@iZm5e8ucr8vsejbzgby5olZ ~]# docker run -d \
> -p 3344:3306 \
> --volumes-from mysql01 \
> -e MYSQL_ROOT_PASSWORD=123 \
> --name mysql02 \
> mysql:5.7
952eb4a9b7cec8e21b058778c3e97cb68b513e3e54ffcd10c5023c9fd1743081
```

**删除父容器，数据还在，删除所有容器，数据消失。备份机制** 
