### 1. 应用

工作流被应用于：（自己的一些想法）

* 科学计算（Montage、CyberShake...）
* 大数据处理计算引擎（hadoop、spark、storm...）
* 机器学习（TensorFlow...）

GPU运算，调度算法需要根据具体应用场景设计。

### 2. 数据集

J.Meena 等人在文献 [1] 中针对科学计算方向提出了一种调度算法，其中数据源来自 USC ISI，该研究所还开发了工作流管理系统 pegasus。

USC ISI 根据 [2]、[3] 对科学计算工作流的描述和实际的工作流数据开发了工作流生成器 [WorkflowGenerator](https://github.com/pegasus-isi/WorkflowGenerator) ，它可以生成人工合成工作流用于评估调度算法。

WorkflowGenerator 使用 XML 文件来描述工作流，每个 XML 文件包括三部分：

* 文件依赖
* job 描述（运行时间，文件大小）
* 执行顺序依赖

### 3. Simulation

WorkflowGenerator 生成的工作流可以使用 [WorkflowSim](http://workflowsim.org/) 进行模拟，文献 [1] 中实验中应该采用的就是这种方法。WorkflowSim 有以下特点：

* java 编写，开源
* 可以扩充调度算法
* 底层调用的是CloudSim（依赖CloudSim）

### 4. Future Work

以下讨论均在在文献 [1] 的基础上。

1. 节点之间数据传输使用 Amazon EBS 服务（带宽设为定值20kbps）。
   $$
   TT(e_{ij}) = Data(t_i, out)/\beta
   $$
   **改进**：带宽 $\beta$ 应该是波动的，实测数据后建立时序模型预测带宽。

2. VMs 性能波动 $\sim N(12, 10)$ 。

   **改进**：实测 VMs 的不同时段数据，建立时序模型预测性能。

3. VMs 获取延迟设为定值 60s。

   **改进**：实测不同提供商不同时段 VMs 的获取时间，建立时序模型预测获取时间。

4. Vms 关闭延时没有考虑，关闭延时对整体花费有影响。

   **改进**：模型中加入 VMs 关闭延迟。

5. **改进**：可以从能耗方向建立模型，设计调度算法。

6. GPU 运算

7. 计算需要大量的时间，那么调度是否可以动态调度？

### 5. 问题

* 能否将这个方向的研究作为我专业硕士的毕业设计？
* 老师之前让我看的静态调度算法 [4] 会用到什么地方？

### 6. 参考

[1] Meena, J., Kumar, M., & Vardhan, M. (2016). Cost Effective Genetic Algorithm for Workflow Scheduling in Cloud Under Deadline Constraint. *IEEE Access*, *4*, 5065–5082.

[2] Bharathi, S., Chervenak, A., Deelman, E., Mehta, G., Su, M.-H., & Vahi, K. (2008). Characterization of scientific workflows. In *Workflows in Support of Large-Scale Science, 2008. WORKS 2008. Third Workshop on* (pp. 1–10). IEEE.

[3] Juve, G., Chervenak, A., Deelman, E., Bharathi, S., Mehta, G., & Vahi, K. (2013). Characterizing and profiling scientific workflows. *Future Generation Computer Systems*, *29*(3), 682–692.

[4] Kwok, Y.-K., & Ahmad, I. (1999). Static scheduling algorithms for allocating directed task graphs to multiprocessors. *ACM Computing Surveys (CSUR)*, *31*(4), 406–471.