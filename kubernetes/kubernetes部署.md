# docker部署
### 系统需求
    // ubuntu 14.04  docker版本1.10.1 
    // 卸载已有环境
    apt-get purge docker-engine
### 安装docker

    sudo apt-get update
    sudo apt-get install apt-transport-https ca-certificates
    sudo apt-key adv --keyserver hkp://p80.pool.sks-    keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    // 打开 /etc/apt/sources.list.d/docker.list 若无，则创建
    // 写入：deb https://apt.dockerproject.org/repo ubuntu-trusty main
    sudo apt-get update
    sudo apt-get purge lxc-docker
    apt-cache policy docker-engine
    sudo apt-get update
    sudo apt-get install linux-image-extra-$(uname -r)
    sudo apt-get update
    sudo apt-get install docker-engine=1.10.1-0~trusty
    sudo service docker start
    // install docker-engine 速度慢可用使用deb安装
    // 镜像地址 http://mirrors.aliyun.com/docker-engine/apt/repo/pool/main/d/docker-engine/docker-engine_1.10.1-0~trusty_amd64.deb
    // sudo dpkg -i docker-engine_1.10.1-0~trusty_amd64.deb
### 参考地址

https://docs.docker.com/engine/installation/linux/ubuntulinux/


# kubernetes部署

### 系统需求


1. docker version 1.2 以上以及 bridge-utils（默认ubuntu都有）
2. 所有节点机器网络互通
3. ubuntu 14.04 
4. 多节点需要进行配置ssh连接不需要密码[1]

### 准备工作

1. github下载二进制包 kubernetes.tar.gz 并解压 (本实验选择1.3.5版本)
2. 其中 kubernetes/platforms/linux/amd64/kubectl 是与 apiserver 交互的 client 程序
3. 解压 kubernetes/server/kubernetes-server-linux-amd64.tar.gz
4. 在解压到的 kubernetes 文件夹中找到 kubernetes-src.tar.gz 文件
5. 解压 kubernetes-src.tar.gz 得到源码
6. 以下类似 kubernetes/cluster/... 路径中的 kubernetes 文件夹均指kubernetes-src.tar.gz 解压出的文件夹

### 部署步骤

1. 根据部署环境 修改kubernetes/cluster/ubuntu/config-default.sh 里的配置[2]
2. 运行修改好的config-default.sh
        
        ./config-default.sh
3. 设置版本环境变量

        export KUBE_VERSION=1.3.5     // kubernetes的版本
        export FLANNEL_VERSION=0.5.5  // flannel的版本
        export ETCD_VERSION=2.2.1     // etcd的版本
4. 为了安装进度,将 etcd.tar.gz flannel.tar.gz kubernetes.tar.gz(提前下载好，改好名字) 拷贝到kubernetes/cluster/ubuntu下，并且修改该目录的download-release.sh，注释掉以下语句
        

        # curl https://github.com/coreos/flannel/releases/download/v${FLANNEL_VERSION}/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz -o flannel.tar.gz
        # curl -L https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/${ETCD}.tar.gz -o etcd.tar.gz
        # curl -L https://github.com/kubernetes/kubernetes/releases/download/v${KUBE_VERSION}/kubernetes.tar.gz -o kubernetes.tar.gz

        
5. 启动安装脚本

        // 在 kubernetes/cluster/ 目录下运行
        KUBERNETES_PROVIDER=ubuntu ./kube-up.sh
6. DNS配置


        // 在 kubernetes/cluster/ubuntu 目录下运行
        KUBERNETES_PROVIDER=ubuntu ./deployAddons.sh

### 参考地址

http://kubernetes.io/docs/getting-started-guides/ubuntu/

# 重启kubernetes
1. 首先到kubernetes/cluster/，命运行
        
        KUBERNETES_PROVIDER=ubuntu ./kube-down.sh

2. ssh到其他节点
		

        cd  /opt/bin
        rm  -rf  *
        service flanneld stop
        service kube stop
        service kubelet stop
        service kube-proxy stop
        cd /etc/default/
        rm flanneld
        rm kubelet
        rm kube-proxy
        exit // 退出
3. 进入 /kubernetes/cluster/  运行

        KUBERNETES_PROVIDER=ubuntu ./kube-.sh 



# 附录

### [1] 配置ssh无密码登录

实验中 TargetUser 用户为 root 用户


    ssh=keygen -t dsa
    scp /root/.ssh/id-dsa.pub <TargetUser>@<TargetIP>:~
    ssh <TargetUser>@<TargetIP>
    cat id_dsa.pub >> ~/.ssh/authorized_keys
    chmod +x ~/.ssh/authorized_keys 


### [2] 配置k8s的export详解


    // 代表所要部署的节点，使用ssh连接的用户名@节点地址
    export nodes=${nodes:-"root@10.10.103.121 root@10.10.103.120"}

    // 代表各节点的属性，‘ai’表示既是主机也是节点，‘a’表示是主机，‘i'表示时节点
    roles=${roles:-"ai i"} export roles_array=($roles)

    // 代表节点个数
    export NUM_NODES=${NUM_NODES:-2}

    // 代表kubernetes服务IP范围，可根据RFC1918使用以下三个私有网络范围进行定义，不要与自己专用的私有网络冲突
    export SERVICE_CLUSTER_IP_RANGE=${SERVICE_CLUSTER_IP_RANGE:-192.168.3.0/24}

三个私有网络范围：

* 10.0.0.0 - 10.255.255.255 (10/8 prefix)
* 172.16.0.0 - 172.31.255.255 (172.16/12 prefix)
* 192.168.0.0 - 192.168.255.255 (192.168/16 prefix)



