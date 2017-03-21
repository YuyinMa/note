### Source

**A comprehensive QoS determination model for Infrastructure-as-a-Service clouds**
IEEE Conference Publications
**2013 IEEE International Conference on Automation Science and Engineering (CASE)**
2013

### Abstract

Cloud computing is a recently developed new technology for complex systems with massive service sharing, which is different from the resource sharing of the grid computing systems. In a cloud environment, service requests from users go through numerous provider specific steps from the instant it is submitted to when the service is fully delivered. 

Quality modeling and analysis of clouds are not easy tasks because of the complexity of the provisioning mechanism and the dynamic cloud environment. 

This study proposes（提出） an analytical model-based approach for quality evaluation（评估） of Infrastructure-as-a- Service cloud and consider expected request completion time, rejection probability, and system overhead rate as key QoS metrics. It also features with the modeling of different warming and cooling strategies of machines and the ability to identify the optimal balance between system overhead and performance.

### CONTENT

与 [Stochastic Modeling and Quality Evaluation of Infrastructure-as-a-Service Clouds](./2015-IaaS云的随机建模和质量评估.md) 基本一致

### I. INTRODUCTION

1. 云计算科普

2. 云的 QoS 需求很迫切，传统的软件 QoS 模型不能用于云

3. 用户眼中最重要的两个指标

   * $\ E(RCT) $
   * $\ RJ$

   系统层面的重要指标

   * $\ SOR$

4. 使用基于测量的 QoS 评估不好

   * 需要进行大量实验（每个负载，每个配置）
   * 捕捉不到足够的错误

5. 本文目的：提出一个 QoS 模型用于估算$\ E(RCT), RJ, SOR$ ，并有助于选择最优的性能能耗平衡点

### II. SYSTEM MODEL

1. CMU 工作机制
2. PM 的四种状态
3. PM 的状态转换
4. Alive PMs 的失败和修复

### III. QOS MODELING OF IAAS CLOUDS

1. 对参数的分布做假设
2. CMU 处理阶段为$\ M/M/1/K$ 模型
3. 计算 job 输出速率$\ \lambda_{p}$，CMU 处理阶段拒绝概率$\ RJC$
4. job 执行阶段的状态转移描述，得到状态转移率矩阵$\ Q$
5. 推导状态处于稳态的概率$\ \pi$
6. 总$\ RJ$ 的计算
7. $\ SOR$ 的推导
8. $\ E(RCT)$ 的推导

### IV. RESULTS AND COMPARISONS

1.  使用 Matlab 进行仿真实验
2.  关键指标的定量分析
    * "early warming" and "early cooling" strategies
    * PM repair rate
    * job execution rate

### V. CONCLUSIONS

1. 本文总结

### 建模

参数输入：

1. Request arrival rate $\ \lambda$
2. Request divided into jobs $\ Pr(X=i) = g_{i} (i \ge 1)$
3. CMU handle requests rate $\ \mu_c$
4. PMs execute jobs rate $\ \mu_p$
5. Capacity of CMU queue $\ q_{c}$
6. Capacity of jobs queue $\ q_{p}$
7. Time to failure rate $\ \gamma_{f}$
8. Time to rapire rate $\ \gamma_{r}$
9. Warm-up rate $\ \beta_{w}$
10. Cool-down rate $\ \beta_{c}$
11. Maintaining time $\ c/w/h$
12. Initial number of PMs $\ n_{c}/n_{w}/n_{h}$

