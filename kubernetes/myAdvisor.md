### myAdvisor

myAdvisor是一个收集节点(物理机)上进程级别信息的一个agent，它运行在kubernetes集群之外

 ### 运行myAdvisor

1. 准备go环境

2. 下载

   ```sh
   git clone https://git.oschina.net/qinglanpeng/myAdvisor.git
   ```

3. 编译

   ```sh
   cd myAdvisor
   go install
   ```

4. 配置

   在myAdvisor可执行文件的目录下创建文件advisor-conf.json

   修改配置

   ```json
   {
     "HostIp": "localhost",                // 暂时没有使用
     "Port": 8086,							// 暂时没有使用
     "Url": "http://192.168.1.49:30016",   // Infludb地址
     "DB": "k8s",
     "Instructions":
     [
       "ps -e -o pid,comm,pcpu,pmem | grep kubelet",
       "ps -e -o pid,comm,pcpu,pmem | grep kube-proxy",
       "ps -e -o pid,comm,pcpu,pmem | grep kube-apiserver",
       "ps -e -o pid,comm,pcpu,pmem | grep kube-controller",
       "ps -e -o pid,comm,pcpu,pmem | grep kube-scheduler"
     ],
     "Freq": 30,        // 发送间隔
     "Username": "",    // 用户名
     "Password": ""     // 密码
   }
   ```

5. 运行

   ```sh
   nohup ./myAdvisor & 
   ```

6. 检查运行结果，看到process/cpu/mem度量

    ![检查度量](https://github.com/pengqinglan/note/blob/master/img/myAdvisor-1.png)


7. 查询 ![查询结果](https://github.com/pengqinglan/note/blob/master/img/myAdvisor-2.png)

### 流程图 ![流程图](https://github.com/pengqinglan/note/blob/master/img/myAdvisor-3.jpg)
