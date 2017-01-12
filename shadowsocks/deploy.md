### 官方网站

https://shadowsocks.org

不是https://shadowsocks.com

### 版本

有Python、go、C各种版本的server

### python 和 go版本的区别

python：

* 简单易用
* 易于部署
* 基本功能

go：

* 大规模
* 多端口，多密码（多用户）
* 用于提供商业服务
* 具有流量统计功能

### shadowsocks-go的安装与配置

1. 下载go语言

   ```sh
   $ wget https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz
   ```

2. 解压到/usr/local

   ```sh
   $ tar -C /usr/local -xzf go1.7.4.linux-amd64.tar.gz
   ```

3. 配置环境变量（当前为root用户）

   ```sh
   $ cd ~
   $ mkdir work
   $ echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
   $ echo 'export GOROOT=/usr/local/go' >> /etc/profile
   $ echo 'export PATH=$PATH:$GOROOT/bin' >> /etc/profile
   $ echo 'export GOPATH=$HOME/work' >> /etc/profile
   $ echo 'export PATH=$PATH:$GOPATH/bin' >> /etc/profile
   $ source /etc/profile
   ```

4. 检查安装

   ```sh
   $ go version
   go version go1.7.4 linux/amd64
   ```

5. 安装ss

   ```sh
   $ go get github.com/shadowsocks/shadowsocks-go/cmd/shadowsocks-server
   ```

6. 配置启动参数

   ```sh
   $ cd $GOPATH/bin
   $ cat >> config.json <<EOF
   {
       "server":"127.0.0.1",
       "server_port":8388,
       "local_port":1080,
       "password":"passwd",
       "method": "aes-128-cfb-auth",
       "timeout":600
   }
   EOF
   ```

7. 启动ss-server

   ```sh
   $ shadowsocks-server > log &
   ```


### 安装shadowsocks-libev

1. 下载源码

   ```sh
   $ wget https://codeload.github.com/shadowsocks/shadowsocks-libev/tar.gz/v2.5.6
   ```

2. 编译安装

   ```sh
   $ cd shadowsocks-libev
   $ sudo apt-get install --no-install-recommends build-essential autoconf libtool libssl-dev gawk debhelper dh-systemd init-system-helpers pkg-config asciidoc xmlto apg libpcre3-dev zlib1g-dev
   $ dpkg-buildpackage -b -us -uc -i
   $ cd ..
   $ sudo dpkg -i shadowsocks-libev*.deb
   ```

3. 配置启动参数

   ```sh
   $ sudo vim /etc/shadowsocks-libev/config.json
   ```

4. 启动服务

   ```sh
   $ sudo systemctl start shadowsocks-libev
   ```