### 官方网站

https://shadowsocks.org

不是https://shadowsocks.com

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

### 安装go

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
   $ touch config.json
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

