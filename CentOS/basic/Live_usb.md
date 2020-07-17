# 在linux下制作u盘启动盘
## 1.下载镜像
[win10镜像文件](https://www.microsoft.com/zh-cn/software-download/windows10ISO)
## 2.下载pv(查看进度)
```shell
sudo yum install pv
```
## 3.把镜像文件写入u盘
```shell
sudo dd if=/home/circle/下载/filename.iso of=/dev/sdc	# if为镜像文件的绝对路径，of为u盘位置。
```

## 4.查看进度
```shell
sudo pv -tpreb /home/circle/下载/filename.iso | sudo dd of=/dev/sdc
```
