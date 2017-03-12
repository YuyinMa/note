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

   关闭一次性验证`"auth": false`，有些客户端目前不支持一次性验证

   ```sh
   $ cd $GOPATH/bin
   $ cat >> config.json <<EOF
   {
       "server":"127.0.0.1",
       "server_port":8388,
       "local_port":1080,
       "password":"passwd",
       "method": "aes-128-cfb",
       "timeout":600,
       "auth": false
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
   $ mv v2.5.6 v2.5.6.tar.gz
   $ tar -zxvf v2.5.6.tar.gz
   $ rm v2.5.6.tar.gz
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

### shadowsocks-manager的安装（node.js版本 正在开发中）

1. 下载配置node.js环境

   ```sh
   $ wget https://nodejs.org/dist/v6.9.4/node-v6.9.4-linux-x64.tar.xz
   $ tar -Jxf node-v6.9.4-linux-x64.tar.xz 
   $ mv node-v6.9.4-linux-x64 /usr/local/
   $ echo 'export PATH=$PATH:/usr/local/node-v6.9.4-linux-x64/bin' >> /etc/profile
   $ source /etc/profile
   ```

2. fixing-npm-permissions

   ```sh
   $ mkdir ~/npm-global
   $ npm config set prefix '~/npm-global'
   $ echo 'export PATH=~/npm-global/bin:$PATH' >> ~/.profile
   $ source ~/.profile
   ```

3. 下载安装shadowsocks-manager

   ```sh
   $ git clone https://github.com/shadowsocks/shadowsocks-manager.git
   $ cd shadowsocks-manager/
   $ npm i
   $ npm install -g node-pre-gyp
   $ npm install sqlite3 --save-dev
   ```

4. 配置运行参数

   ```

   ```

### 开启manager API（go环境）

1. 配置多用户

   ```
   $ cd $GOPATH/bin
   $ touch server-multi-passwd.json
   ```

   其中server-multi-passwd.json配置如下

   ```son
   {
       "server": "138.197.209.80",
       "port_password": {
           "8381": "foobar1",
           "8382": "foobar2",
           "8383": "foobar3",
           "8384": "foobar4"
       },
       "timeout": 300,
       "method": "aes-128-cfb"
   }
   ```

2. 启动ss-manager

   两种暴露方式：tcp 、unix socket，安全考虑我们这里使用tcp

   ```sh
   ss-manager -m aes-128-cfb -u --manager-address /var/run/shadowsocks-manager.sock -c server-multi-passwd.json
   ```

### manager API测试代码[1]

```python
import socket

cli = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
cli.bind('/tmp/client.sock')  # address of the client
cli.connect('/var/run/shadowsocks-manager.sock')  # address of Shadowsocks manager

# 返回流量信息
cli.send(b'ping')
print(cli.recv(1506))  

# 添加一个用户
cli.send(b'add: {"server_port":8001, "password":"7cd308cc059"}')
print(cli.recv(1506))  # You'll receive 'ok'

# 删除一个用户
cli.send(b'remove: {"server_port":8001}')
print(cli.recv(1506))  # You'll receive 'ok'

# 实验中没有输出
while True:
    print(cli.recv(1506))  # when data is transferred on Shadowsocks, you'll receive stat info every 10 seconds
```

### 参考

[1] shadowsocks Wiki, https://github.com/shadowsocks/shadowsocks/wiki/Manage-Multiple-Users