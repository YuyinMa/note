# Scheduling

## 作者

Michael L. Pinedo

Stern School of Business

New York University New York, NY

USA

## 内容概览

[内容概览](./Scheduling/内容概览.md)

## 1 引言

1. [四个调度的例子](./Scheduling/四个例子.md)
2. 企业中的调度机能（ERP）
3. 本书的大纲
   * Part I (Chapters 2 to 8) 确定性调度模型
   * Part II (Chapters 9 to 13) 随机性调度模型
   * Part III (Chapters 14 to 20) 现实问题的应用和实现

## 2 确定性模型：预热

1. [问题描述符号](./Scheduling/常见符号.md)
2. 一个[调度问题](./Scheduling/常见符号.md)可以被描述为三元组$\ \alpha \vert \beta \vert \gamma$ （机器环境|特征与约束|调度目标）
3. 使用符号表示的几个例子
4. 调度的种类

   * Non-Delay Schedule
   * Active Schedule
   * Semi-Active Schecule
   * 三者的关系，韦恩图
5. 不同调度问题之间的关系
   * 一种调度问题是另一种调度问题的特例
   * 各种调度问题的继承关系
   * 各种约束的继承关系

## 3 确定性模型：简单单机模式

1. 加权完成时间
   * WSPT（Weighted Shortest Processing Time first） 是解决$\ 1 \vert \vert \Sigma w_{j}C_{j}$ 的最优方法
   * WDSPT（Weighted Discounted Shortest Processing Time first） 是解决$\ 1 \vert \vert \Sigma w_{j}(1-e^{-rC_{j}})$ 的最优方法

2. 最大延迟（Lateness）时间
   * $\ 1 \vert  prec \vert h_{max}$ 的最优算法
   * $\ 1 \vert \ r_{j} \vert L_{max}$ 是强$\ NP-hard$  问题

3. 延迟（Trady）的工作数量（背包问题）

   * $\ 1\vert \vert \Sigma U_{j}$ 的最优算法
   * WSPT 方法和背包方法的比较

4. 总延迟时间—动态规划

   * 是 NP-hard 问题


* 最小化总延迟时间算法

5. 总延迟时间—近似方法
   * branch-and-bound 和动态规划都不能在多项式时间内结局问题
   * 近似方法是接近于最优（多项式时间）的方法
   * 使用 FPTAS（Fully Polynomial Time Approximation Scheme）算法来最小化总延迟时间

6. 总加权延迟时间
   * $\ 1 \vert \vert \Sigma w_{j}T_{j}$ 是强$\ NP-hard$  问题
   * 使用 branch-and-bound 来解决此问题

## 4 确定性模型：高级单机模式

1. 总提前时间和总延迟时间
   * 最小化总提前和延迟算法：Loose Due Date
   * 最小化总提前和延迟算法：Tight Due Date
   * 给定序列，最优化时间控制算法
2. 多个优化目标：首要和次要
   * 算法：使用 Deadlines 来最小化总完成时间
3. 多目标：参数化分析
   * Pareto最优序
   * 算法：总完成时间和总延迟的权衡决定
4. 考虑到 Sequence dependent setup 的完工时间
   * 算法：找到 TSP 的最优路程
5. Job Famil with setup time
   * 算法：最小总完成时间
   * 算法：最小化最大延迟
   * 算法：最小化延迟工作数
6. 批处理
   * 算法：最优化总加权完成时间（批处理无限大）
   * 算法：最小化最大延迟（批处理无限大）
   * 算法：最小化延迟的job数量（批处理无限大）
   * 算法：最小化完工时间（批处理有限）

## 5 确定性模型：并行模式

1. 没有抢占的最长完工时间（makespan）
   * 使用 LPT（Longest Processing Time first） 来处理 $P_m\vert\vert C_{max}$  问题
   * OPT（最佳） 和 LPT 的逼近率
   * 算法：最小化最长完工时间（使用CP）
   * CP 规则是 $Pm\vert p_j = 1, intree\vert C_{max},P_m\vert p_j=1,outtree|c_{max}$ 的最优解
   * LNS（Largest Number of Successors first） 规则
   * LFJ（Least Flexible Job first）规则
   * LFJ 规则是 $Pm | p_m = 1,M_j | C_{max}$ 问题的最优解，当 $M_j$ set 为嵌套时
2. 有抢占的最大完工时间
   * 最小化有抢占的工程的最大完工时间
   * 定理
   * 例子
3. 没有抢占的总完工时间
   * 定理
4. 有抢占的总完工时间
5. 与交付时间相关的目标
6. 在线调度

## 6 确定性模型：流水线和柔性流水线

1. 具有无限中间存储的流水车间
2. 有限中间存储的流水车间
3. 具有无限中间存储的柔性流水车间

## 7 确定性模型：加工车间

1. 分隔编程和分支界限法
2. 移动瓶颈探索和完工时间
3. 移动瓶颈探索和总延迟时间
4. 约束编程和完工时间

## 8 确定性模型： 开放车间

1. 有抢占的完工时间
2. 无抢占的完工时间
3. 无抢占的最大延迟
4. 有抢占的最大延迟
5. 缓慢任务的数量

## 9 随机模型：预热