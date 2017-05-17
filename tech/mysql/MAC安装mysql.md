以压缩包的形式安装 mysql

材料：mysql-5.7.13-osx10.11-x86_64.tar

步骤

```sh
sudo mv mysql-5.7.13-osx10.11-x86_64 /usr/local
cd /usr/local
sudo mv mysql-5.7.13-osx10.11-x86_64 mysql
sudo ./mysqld --initialize
```