# vim安装插件依赖

## 安装vim-Plug

```shell
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## coc.nvim依赖

```shell
brew install node
sudo npm i -g neovim yarn
```

## vim-instant-markdown依赖

```shell
sudo npm install instant-markdown-d
```

## Mac安装字体

```shell
brew tap homebrew/cask-fonts
brew cask install font-inconsolata
```

## Mac 安装iTerm2

```shell
brew cask install iterm2
```

## Mac安装tmux

```shell
brew cask install tmux

cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
```
