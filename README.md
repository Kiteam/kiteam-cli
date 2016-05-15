# kiteam-cli

Kiteam的命令行工具，用于初始化Kiteam，以及启动Kiteam等

# 安装

sudo npm install kiteam -g

# 命令


* `kiteam init`， 下载Kiteam项目，并打包编译为产品环境
* `kiteam start [-p]`，这将调用`Kiteam`下的`forever`启动Kiteam，你也可以自己使用forever或者pm2启动项目。
* `kiteam stop`，停止kiteam
* `kiteam update [-v]`，更新kiteam，允许指定版本