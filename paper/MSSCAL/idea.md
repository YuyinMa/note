### 问题来源

1. 容器技术的发展推动了微服务架构的流行（SOA与微服务架构有什么区别？）[1]
2. 微服务架构与传统的单体应用在扩容上不同 [2]
3. 微服务架构的扩容面临着很难确定某个服务需要多少资源的问题 [2]
4. 传统的扩容方式（kubernetes）基于阈值，比较粗放，没有考虑到服务之间的依赖关系 [3-4]

### 我们的改进

1. 使用预测负载的方法代替阈值触发方法
2. 将服务之间的依赖关系（因素）加入到负载预测上

### 预测方法

多元时间序列预测方法 [5]

* 整个应用由微服务构成，微服务之间组成了依赖链，一个微服务可以属于多条依赖链


* 一条依赖链中包含多个微服务
* 所有的微服务，和服务之间的依赖构成了一个有向图
* 求出有向图中的所有强联通分量（其实是联通分量？），然后将每一个联通分量独立作为一个动力系统
* 每个动力系统中的每个服务可以看做是一个维度
* 使用多维负载预测技术，预测每一个维度负载，进行扩容

### 对比实验

1. 基于阈值的伸缩
2. 基于预测的伸缩
3. 基于依赖预测的伸缩



### 参考

[1] https://www.zhihu.com/question/37808426

[2] https://opentalk.upyun.com/309.html

[3] https://www.cnblogs.com/zhangeamon/p/7059488.html?utm_source=itdadao&utm_medium=referral

[4] http://www.dockerinfo.net/1095.html 

[5] Zhang, P., Wang, L., Li, W., Leung, H., & Song, W. (2017). A Web Service QoS Forecasting Approach Based on Multivariate Time Series. In *Web Services (ICWS), 2017 IEEE International Conference on* (pp. 146–153). IEEE.