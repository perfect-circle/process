## 进入ip设置文件夹
```shell
cd /etc/sysconfig/network-scriptsif 
```

## 配置文件
```shell
ls      # 查看网卡的配置文件
vim ifcfg-eth0
```

```shell
#将IPV6…..协议都注释；
BOOTPROTO=static        #开机协议，有dhcp及static；
ONBOOT=yes              #设置为开机启动；
DNS1=114.114.114.114    #这个是国内的DNS地址，是固定的；
IPADDR=192.168.2.2      #你想要设置的固定IP，理论上192.168.2.2-255之间都可以，请自行验证；
NETMASK=255.255.255.0   #子网掩码，不需要修改；
GATEWAY=192.168.2.1     #网关，这里是你在“2.配置虚拟机的NAT模式具体地址参数”中的（2）选择VMnet8--取消勾选使用本地DHCP--设置子网IP--网关IP设置。
```

## 重新启动服务
```shell
service network restart
```

## 配置文件的注意事项
1. 要查看KVM的虚拟网络段，IP地址的选择范围要在其中
2. 网关的选择也要虚拟网段范围内