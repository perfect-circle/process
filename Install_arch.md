# Arch Linux 安装教程

## 准备工作
### 官方文档    <https://wiki.archlinux.org/index.php/lnstallation_guide>
### 下载Arch Linux    <https://www.archlinux.org/download/>
### 下载U盘制作工具      <http://rufus.ie/>

## 安装Arch Linux
> 第一步：更新时间   
>```timedatectl set-mtp true```

> 第二步：分区    
> ```fdisk -l```  # 查看磁盘    
> ```fdisk /dev/sda```    # 给磁盘分区    
* 分为3个分区    
    - /boot 512M 分区1 /dev/sda1
    - /mnt  剩余全部    /dev/sda2
    - /swap 1G 分区3 /dev/sda3

> 第三步：格式化分区    
> ```mkfs.fat -F32 /dev/sda1```     # 格式化引导分区   
> ```mkfs.ext4 /dev/sda2```         # 格式化主分区    
> ```mkswap /dev/sda3```            # 格式化swap分区    
> ```swapon /dev/sda3```            # 启动swap分区    

> 第四步：配置安装源    
> ```vim /etc/pacman.conf```   
  找到[community]   
  按gf进入文件/etc/pacman.d/mirrorlist    
  把China的源剪切到文件最顶部    

> 第五步：挂载分区    
> ```mount /dev/sda2 /mnt```    # 挂载主分区     
> ``` mkdir /mnt/boot```        # 创建启动分区     
> ```mount /dev/sda1 /mnt/boot```   # 挂载启动分区     

> 第六步:安装    
> ```pacstrap /mnt base linux linux-firmware```     
> ```genfstab -U /mnt >> /mnt/etc/fstab```     

> 第七步：进去系统    
> ```arch-chroot /mnt```    # 进去系统     
> ```ln -sf /usr/share/zoneinfo/Asia/Shanghia /etc/localtime``` # 更新时区     
> ```hwclock --systohc```    
> ```exit```    # 退出系统     

> 第八步：配置系统     
> ```vim /mnt/etc/locale.gen``` # 配置编码格式，在文件中去掉zn_US.UTF-8 UTF-8的批注   
> ```arch-chroot /mnt```   
> ```locale-gen```  # 生成配置文件   
> ```exit```   
> ```vim /mnt/etc/locale.conf```    # 写入‘LANF=zn_US.UTF-8'   
> ```vim /mnt/etc/hostname```       # 写入你想要的主机名，例如’CIRCLE‘   
> ```vim /mnt/etc/hosts```          # 配置网络   
>> 写入：    
 ```127.0.0.1  localhost```     
 ```::1        localhost```      
 ```127.0.1.1  CIRCLE.localdomain   CIRCLE```      
>
>```arch-chroot```    
> ```passwd```   #配置密码   

>第九步：下载启动软件       
> ```pacman -S grub efibootmgr intel-ucode os-prober```      
> ```mkdir /boot/grub```       
> ```grub-mkconfig > /boot/grub/grub.cfg```     
> ```unmae -m```    # 查看架构     
> ```grup-install --target=x86_64-efi --efi-directory=/boot```      # 安装多系统引导     
> ```pacman -S wpa_supplicant dhcpcd```     # 安装联网工具     
> ```killall wpa_suplicant dhcpcd```     
> ```reboot```  # 安装完毕     
