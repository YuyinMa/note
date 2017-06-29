### 一、调研工作

**1. 移动计算**

邓水光在杂志上提出了对于移动计算中节能方向的思考[1]

* 需要一个精确数学模型来描述处理移动服务和设备能耗之间的关系
  * 已有模型[2]（回归方法）
  * 不同设备下如何处理？
  * 需要一个精准的能耗描述（通过对用户行为分析，CPU运行时间，OS自身）
* 精确地描述不容易得到，我们可以使用预测的方法来得到能耗模型
  * 回归
  * 神经网络
* 根据得到的能耗模型，我们需要一个可行的方法在运行时改变计算参数来降低能耗

**2. 服务组合**

邓水光提出了一种考虑到数据传输能耗的移动服务组合方案[3]，移动用户在不同的位置信号强度不同，信号强度不同数据传输速度也不同，从而完成一次服务调用的能耗就不同，他在论文中根据用户的移动轨迹来辅助移动服务选择，从而达到节能的目的。

**3. workflow调度**

* TensorFlow 可以应用在移动设备上，可以实现一些简单的分类、识别，在未来我们可以使用移动设备来随时随地享受到更多的 AI 服务
* TensorFlow 的计算过程可以看做是一个 DAG 图，移动计算本质上是一个 workfow 调度问题
* 将 Job 分配周围合适的设备上，可以充分利用周边设备的剩余计算能力和传感器

**4. Mobile Ad Hoc Network**

* 达沃斯论坛共享经济[4]

### 二、应用场景

**1. 空气质量传感器，拥挤度，舒适度（周围）**

**2. 神经网络训练**

**3. 资源共享（流量，带宽，计算能力，电池）**

### 三、方案

**1. 能耗感知的移动机会网络下的服务选择**

**2. 能耗感知的移动机会网络下的服务组合**

**3. 机会机会网络下的workflow调度算法**

### 参考

[1] Deng, S., Huang, L., Wu, H., Tan, W., Taheri, J., Zomaya, A. Y., & Wu, Z. (2016). Toward Mobile Service Computing: Opportunities and Challenges. *IEEE Cloud Computing*, *3*(4), 32–41.

[2] Papageorgiou, A., Lampe, U., Schuller, D., & Steinmetz, R. (2012). Invoking Web Services based on Energy Consumption Models. https://doi.org/10.1109/MobServ.2012.12

[3] Deng, S., Wu, H., Tan, W., Xiang, Z., & Wu, Z. (2015). Mobile service selection for composition: an energy consumption perspective. *IEEE Transactions on Automation Science and Engineering*.

[4] http://www.huaxia.com/xw/zhxw/2017/06/5374557.html

[5] 

[6] 

[7] 

[8] 