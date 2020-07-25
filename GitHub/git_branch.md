# Git分支操作
## 一、添加SSH关联授权
```shell
ssh-keygen	# 多按几次Enter，生成公私钥
cat ~/.ssh/id_ras.pub	# 将内容复制到Github上
```

## 二、为Git命令设置别名
```shell
git config --global alias.st status	# 将status改为st
git config --global alias.br 'branch -avv' 
cat -n ~/.gitconfig	# 查看配置文件
```

## 三、分支管理

