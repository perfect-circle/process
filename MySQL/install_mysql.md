# 安装mysql    
```shell    
wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm    
```    
    
# 安装rpm包    
```shell    
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm    
```    
    
# 安装mysql-server    
```shell    
sudo yum -y install mysql-server    
```    
    
# 重启mysql服务    
```shell    
sudo service mysqld restart    
sudo systemctl restart mysql.service    
```    
    
# 用root登陆mysql    
```shell    
mysql -u root    
```    
    
# 在mysql中修改密码    
```sql    
update user set password=password('new password') where user='root';    
flush privileges;       # 刷新权限    
```    
# 配置mysql    
## 1. 编码问题（中文乱码）    
```shell    
sudo vim /etc/my.cof    
```    
    
```    
[mysql]    
default-character-set = utf8    
```    
    
```shell    
sudo vim /usr/share/mysql/charsets/Lndex.xml    
```    
```</description>    
    
<charset name="utf8">    
  <family>Unicode</family>    
  <description>UTF-8 Unicode</description>    
  <alias>utf-8</alias>    
  <collation name="utf8_general_ci"     id="33">    
    <flag>primary</flag>    
    <flag>compiled</flag>    
  </collation>    
  <collation name="utf8_bin"    id="83">    
    <flag>binary</flag>    
    <flag>compiled</flag>    
  </collation>    
</charset>    
```      
    
