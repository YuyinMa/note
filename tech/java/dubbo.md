实验材料源于：http://download.csdn.net/detail/shmilzl/9383130

1.dubbo+spring+zookeer在windows完全能用.
(1)下载zookeeper3.4.6.直接解压,将zoo-sample.cfg修改名字为conf/zoo.cfg,并修改里面的一句话--数据存放路径,如我这里是:
dataDir=E:/zookeeper-3.4.6/data/tmp/zookeeper
(2)bin/zkServer.cmd启动zookeeper.
(3)直接运行dubboC2里面的zkServer.cmd的main方法启动服务类.打印出:Press any key to exit.为成功.
(4)直接运行dubboC2里面的zkServer.cmd的main方法启动服务类.打印出:打印结果 ,同时C2那边打印出"我打印"为成功.
2.注意事项.
启动dubboC2的服务后,zookeeper报错:
Error Path:/dubbo/com.jinbin.service.customer.CustomerService Error:KeeperErrorCode = NodeExists for /dubbo/com.jinbin.service.customer.CustomerService
这不是错误,这个是成功的意思..对于zookeeper这种行为,我只想说:没有最坑,只有更坑!
本文主要思路来自:http://www.tuicool.com/articles/QjaArm这位大牛的原创!!