### 离线情况下安装 ipk 包

1. 确认路由器 SoC 型号

   https://wiki.openwrt.org/toh/start

2. 下载安装包

   * openwrt下载页面 https://downloads.openwrt.org/
   * 找到自己的openwrt版本
   * 进入自己 SoC 相应的页面，如 https://downloads.openwrt.org/chaos_calmer/15.05.1/ar71xx/generic/packages/

3. SCP 到路由器

   ```sh
   $ scp filename root@192.168.10.1:~
   ```

4. opkg 命令安装

   ```shell
   $ opkg install xxxx
   ```

   ​

### python 依赖

1. 安装 python-base_2.7.9-6_ar71xx.ipk （基本包）
2. 安装 libffi_3.0.13-1_ar71xx.ipk （python-light 依赖）
3. 安装 libbz2_1.0.6-2_ar71xx.ipk （python-light 依赖）
4. 安装 python-light_2.7.9-6_ar71xx.ipk （socket 依赖）
5. 安装 python-logging_2.7.9-6_ar71xx.ipk （logging 依赖）
6. 安装 python-openssl_2.7.9-6_ar71xx.ipk （MD5 依赖）
7. 安装 python-codecs_2.7.9-6_ar71xx.ipk （mac编码 依赖）