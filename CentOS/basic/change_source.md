## 进入yum源的文件夹
```shell
cd /etc/yum.repos.d
```

## 备份旧的配置文件
```shell
sudo mv CentOS-Base.repo CenOS-Base.repo.bak
```

## 下载阿里源文件
```shell
sudo wget -O CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

## 下载epel repo源
```shell
sudo wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

## 清理缓存
```shell
yum clean all
```

## 重新生成缓存
```shell
yum makecache
```
