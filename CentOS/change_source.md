## 进入yum源的文件夹
```python
cd /etc/yum.repos.d
```

## 备份旧的配置文件
```python
sudo mv CentOS-Base.repo CenOS-Base.repo.bak
```

## 下载阿里源文件
```python
sudo wget -O CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

## 下载epel repo源
```python
sudo wegt -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

## 清理缓存
```python
yum clean all
```

## 重新生成缓存
```python
yum makecache
```