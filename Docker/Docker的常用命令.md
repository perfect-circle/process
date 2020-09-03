# Docker的常用命令

## 帮助命令
```shell
docker version		# docker的版本信息
docker info			# 显示docker的系统信息，包括镜像和容器的数量
docker 命令 --help 		# 帮助命令
```

[帮助文档](https://docs.docker.com/reference/) 

## 镜像命令

**查看Docker镜像** 

```shell
docker images	# 查看所以的镜像
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
centos              latest              0d120b6ccaa8        3 weeks ago         215MB
mysql               latest              0d64f46acfd1        4 weeks ago         544MB

# 解释
REPOSITORY	镜像仓库源
TAG		镜像的标签
IMAGE ID	镜像ID
CREATED		镜像的创建时间
SIZE		镜像的大小

Options:
  -a, --all             Show all images (default hides intermediate images)
      --digests         Show digests
  -f, --filter filter   Filter output based on conditions provided
      --format string   Pretty-print images using a Go template
      --no-trunc        Don't truncate output
  -q, --quiet           Only show numeric IDs
```
**Docker search搜索镜像命令** 

```shell
[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker search mysql
NAME                              DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
mysql                             MySQL is a widely used, open-source relation…   9920                [OK]
mariadb                           MariaDB is a community-developed fork of MyS…   3630                [OK]
mysql/mysql-server                Optimized MySQL Server Docker images. Create…   723                                     [OK]

Options:
	--filter=STAES=3000	# STAES>3000的镜像
```

**镜像下载** 


```shell
# 下载镜像docker pull 镜像名 [:tag] 

[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker pull redis
Using default tag: latest	#不写tag自动下载最新
latest: Pulling from library/redis
bf5952930446: Already exists	# 分层下载，docker image的核心，联合文件系统
911b8422b695: Pull complete
093b947e0ade: Pull complete
c7616728f575: Pull complete
61a55f107028: Pull complete
0ee3e0cb4e07: Pull complete
Digest: sha256:933c6c01829165885ea8468d87f71127b1cb76a711311e6c63708097e92ee3d1	# 签名
Status: Downloaded newer image for redis:latest
docker.io/library/redis:latest	# 真实地址

# 等价与它
docker pull mysql
docker pull docker.io/library/redis:latest

# 下载固定版本
[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker pull redis:5.0.9
5.0.9: Pulling from library/redis
bf5952930446: Already exists	# 共用镜像
911b8422b695: Already exists
093b947e0ade: Already exists
2e4ea19ac656: Pull complete
62403d50d101: Pull complete
3a097fa7018a: Pull complete
Digest: sha256:ab3998e18bfaa570fad08c884ffbcc7861f59caf736a5a0c1ad5383c4d863958
Status: Downloaded newer image for redis:5.0.9
docker.io/library/redis:5.0.9

```

**删除镜像** 

```shell
# docker rmi -f IMAGE ID

[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker rmi -f  bf756fb1ae65
Untagged: hello-world:latest
Untagged: hello-world@sha256:7f0a9f93b4aa3022c3a4c147a449bf11e0941a1fd0bf4a8e6c9408b2600777c5
Deleted: sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b

# 删除全部镜像
docker rmi -f $(docker images -aq)
```

## 容器命令

**有了镜像才可以创建容器** 

```shell
docker pull centos
```

**新建容器并启动** 

```shell
docker run [可选参数] image

# 参数说明
--name="Name"	# 容器名字
-d		# 后台方式运行
-it 		# 使用交互方式运行，进入容器查看内容
-p		# 自定容器端口 -p 8080:8080

	-p ip:主机端口：端口容器
	-p 主机端口：容器端口 （主机端口映射容器端口，常用）
	-p 容器端口
	容器端口
	
-P 		# 随机端口

```

**启动并进入容器** 

```shell
docker run -it centos /bin/bash		# 启动并进入容器，shell为bash

```

**查看运行的容器** 

```shell
docker ps	# 查看正在运行的容器
docker ps -a 	# 查看正在运行的容器 + 运行过的镜像
docker ps -n=1  # 查看第一个运行的容器
docker ps -aq	# 查看正在运行的容器 + 运行过的镜像的ID

```
**推出容器** 

```shell
exit		# 直接容器停止并退出
Ctrl + P +Q 	# 容器不停止退出
```

**删除容器** 

```shell
docker rm 容器id

docker -rm -f $(docker ps -aq) # 删除所有容器
```

**启动和停止容器** 

```shell
docker start 容器ID 	# 启动容器
docker restart 容器ID	# 重启容器
docker stop 	容器ID	# 停止当前正在运行的容器
docker kill 容器ID	# 强制停止当前容器
```

## 其他常用命令

后提启动容器

```shell
# 命令 docker run -d centos

[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker run -d centos
e28b1e1c4538c2b71f3299e182037e6a94905fdafeadb32865e6d1bdfa36b319
[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

# 问题centos 停止了

# docker容器使用后台运行，就必须要有一个前提进程，docker发现没有应用，就会自动停止
# nginx， 容器启动后，发现自己没有提供服务，就会立刻停止，就是没有程序运行
```

**查看日志** 

```shell
[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker logs --help

Usage:	docker logs [OPTIONS] CONTAINER

Fetch the logs of a container

Options:
      --details        Show extra details provided to logs
  -f, --follow         Follow log output
      --since string   Show logs since timestamp (e.g. 2013-01-02T13:23:37) or relative (e.g. 42m for 42 minutes)
      --tail string    Number of lines to show from the end of the logs (default "all")
  -t, --timestamps     Show timestamps
      --until string   Show logs before a timestamp (e.g. 2013-01-02T13:23:37) or relative (e.g. 42m for 42 minutes)

# 查看日志
[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker logs -tf --tail 10 034a43e4189e
2020-09-03T08:56:19.637059302Z huohao
2020-09-03T08:56:20.639793449Z huohao
2020-09-03T08:56:21.642126016Z huohao
2020-09-03T08:56:22.644158103Z huohao
2020-09-03T08:56:23.646557467Z huohao
2020-09-03T08:56:24.648779670Z huohao

```

**查看容器进程** 

```shell
# 命令docker top 容器ID
[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker top 034a43e4189e
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                19193               19177               0                   16:52               ?                   00:00:00            /bin/sh -c while true; do echo huohao ;sleep 1;done
root                19658               19193               0                   16:59               ?                   00:00:00            /usr/bin/coreutils --coreutils-prog-shebang=sleep /usr/bin/sleep 1

```

**查看容器内部信息** 

```shell
[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker inspect --help

Usage:	docker inspect [OPTIONS] NAME|ID [NAME|ID...]

Return low-level information on Docker objects

Options:
  -f, --format string   Format the output using the given Go template
  -s, --size            Display total file sizes if the type is container
      --type string     Return JSON for specified type


[root@iZm5e8ucr8vsejbzgby5olZ ~]# docker inspect 034a43e4189e
[
    {
        "Id": "034a43e4189e84b250a2d3e9796171aa9b302a6303d3a16afb25e86c0c78b41a",
        "Created": "2020-09-03T08:52:47.818881351Z",
        "Path": "/bin/sh",
        "Args": [
            "-c",
            "while true; do echo huohao ;sleep 1;done"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 19193,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2020-09-03T08:52:48.123137284Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:0d120b6ccaa8c5e149176798b3501d4dd1885f961922497cd0abef155c869566",
        "ResolvConfPath": "/var/lib/docker/containers/034a43e4189e84b250a2d3e9796171aa9b302a6303d3a16afb25e86c0c78b41a/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/034a43e4189e84b250a2d3e9796171aa9b302a6303d3a16afb25e86c0c78b41a/hostname",
        "HostsPath": "/var/lib/docker/containers/034a43e4189e84b250a2d3e9796171aa9b302a6303d3a16afb25e86c0c78b41a/hosts",
        "LogPath": "/var/lib/docker/containers/034a43e4189e84b250a2d3e9796171aa9b302a6303d3a16afb25e86c0c78b41a/034a43e4189e84b250a2d3e9796171aa9b302a6303d3a16afb25e86c0c78b41a-json.log",
        "Name": "/goofy_chaplygin",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Capabilities": null,
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/ab89f52c6bea5f344462aeae9b019a36c875bef6b50c3d98de0dc77f16e71ba2-init/diff:/var/lib/docker/overlay2/65193e67737cf7c3f401fa9dd685df21610f805a0677ec3f51a49e2bdaaa5914/diff",
                "MergedDir": "/var/lib/docker/overlay2/ab89f52c6bea5f344462aeae9b019a36c875bef6b50c3d98de0dc77f16e71ba2/merged",
                "UpperDir": "/var/lib/docker/overlay2/ab89f52c6bea5f344462aeae9b019a36c875bef6b50c3d98de0dc77f16e71ba2/diff",
                "WorkDir": "/var/lib/docker/overlay2/ab89f52c6bea5f344462aeae9b019a36c875bef6b50c3d98de0dc77f16e71ba2/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "034a43e4189e",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "/bin/sh",
                "-c",
                "while true; do echo huohao ;sleep 1;done"
            ],
            "Image": "centos",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {
                "org.label-schema.build-date": "20200809",
                "org.label-schema.license": "GPLv2",
                "org.label-schema.name": "CentOS Base Image",
                "org.label-schema.schema-version": "1.0",
                "org.label-schema.vendor": "CentOS"
            }
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "22d356bdf53a19fe9b8c1836dd95961d2d9d08ba78b8a67d7ef917ad84d8a060",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "/var/run/docker/netns/22d356bdf53a",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "f822ec2dce7e191c97f6597efac1358218518cacba7193c36f4c46f66f472850",
            "Gateway": "172.18.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.18.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:12:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "660b0c25da3102f97317996aad66c989dac845793874c443790416403ad2803f",
                    "EndpointID": "f822ec2dce7e191c97f6597efac1358218518cacba7193c36f4c46f66f472850",
                    "Gateway": "172.18.0.1",
                    "IPAddress": "172.18.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:12:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]

```

**进去当前正在运行的容器** 

```shell
# 我们通常容器都是使用后台方式运行的，需要进入容器，需要修改一些配置

# 命令

docker exec -it 容器ID /bin/bash	# 进去新的shell

docker attach 容器ID 			# 进入正在执行当前的代码
```

**从容器内拷贝文件到主机上** 

```shell
docker cp 容器id：容器内路径 主机路径	# 容器没有启动也可拷贝
```
