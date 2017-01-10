# Docker Swarm架构设计报告

## Docker Swarm

### Swarm背景

现实中我们的应用可能会有很多，应用本身也可能很复杂，单个Docker Engine所能提供的资源未必能够满足要求。而且应用本身也会有可靠性的要求，希望避免单点故障，这样的话势必需要分布在多个Docker Engine。在这样一个大背景下，Docker社区就产生了Swarm项目[1]。

### 什么是Docker Swarm

Swarm这个项目名称特别贴切。Swarm behavior是指动物的集体行为。比如我们常见的蜂群，鱼群，秋天往南飞的雁群都可以称作Swarm behavior。
Swarm项目正是这样，通过把多个Docker Engine聚集在一起，形成一个大的docker-engine，对外提供容器的集群服务。同时这个集群对外提供Swarm API，用户可以像使用Docker Engine一样使用Docker集群[1]。

### Swarm特点

- 对外以Docker API接口呈现，这样带来的好处是，如果现有系统使用Docker Engine，则可以平滑将Docker Engine切到Swarm上，无需改动现有系统。
- Swarm对用户来说，之前使用Docker的经验可以继承过来。非常容易上手，学习成本和二次开发成本都比较低。同时Swarm本身专注于Docker集群管理，非常轻量，占用资源也非常少。 **“Batteries included but swappable”**，简单说，就是插件化机制，Swarm中的各个模块都抽象出了API，可以根据自己一些特点进行定制实现。
- Swarm自身对Docker命令参数支持的比较完善，Swarm目前与Docker是同步发布的。Docker的新功能，都会第一时间在Swarm中体现[1]。

## 概要设计

### 系统质量需求

**一键伸缩**满足了业务爆发增长需求，Docker Swarm可以管理任意规模的应用。不管是10还是10000台服务器，Docker Swarm都可以在整个集群轻松实现弹性扩展。一键扩展应用实例，从而轻松应对业务的爆发式增长。

**资源池化**提高了资源利用率，传统的数据中心或云的资源利用率只有12-15%。Docker Swarm可以将集群资源池化，并将不同应用自动混合部署到整个集群，不受单个服务器边界限制，明显提升了资源利用率。平均可提升400%。混跑应用支持 Docker 容器化应用，以及 Spark、Hadoop、Cassandra 等多种分布式应用。

**混合云管理**支持多环境支持和无缝迁移，Docker Swarm可安装在公有云、私有云、混合云之上。支持物理机、虚拟机。可在多平台间无缝迁移。帮助用户保持统一的开发运维体验。

**一键部署**可以快速搭建企业生产环境，支持一键部署 Docker 容器化应用。（支持企业原有容器化应用，及 Docker Hub 等第三方平台的 Docker 镜像）；可一键部署 Spark、Hadoop、 Cassandra、Jenkins、Kafka 等多种常用分布式应用，从而快速搭建企业生产环境，开发流行的微服务和大数据应用。

**简化运维**可以快速实现 DevOps，打破开发和运维团队之间的障碍，提高应用开发、部署、维护效率。通过统一界面，管理应用和集群。可随时监控每一个应用，集群，主机的运行健康状态。提供 API 接口，可与多种第三方应用，或企业自有管理系统对接整合。可统一收集应用和集群主机日志，能够快速查询和检索，帮助企业快速定位问题。让用户像用单机电脑一样管理集群和云端应用。

**服务高可用**能实现自动容错，永不掉线，当开启高可用服务后，Docker Swarm自动为宕机服务器上运行的节点重新分配资源，保障业务不掉线，高可靠运行。这也就意味着您不用再为一两台服务器的宕机，而经历一个不眠之夜。

### 总体解决方案

我们每天在数百台服务器上运行成百上千个容器，面临的最大一个挑战是怎样高效地调度容器。容器的调度是指在一组服务器上处理容器分配的问题，以保证服务能平稳运行。由于这些需要调度的容器是客户应用程序的组件，我们必须在还未知晓其性能特点之前进行调度。

不合适的调度方法会导致以下可能的结果：

1. 过多的资源配置——意味着更高的成本
2. 过少的资源配置——意味着用户的稳定性差

合适的调度方法对我们而言很重要，以经济高效的方式，提供最好的用户体验。

**随机性调度策略**

起初，在我们的早期产品中使用了相同的调度方法。这个方法（在Docker Swarm之前）没有以任何方式对容器的运行进行约束，而只是简单地随机选择一个服务器。

但是，运行全栈环境和运行代码段是完全不同的事——我们很快发现，这个解决方案并不理想。我们的服务器经常因繁忙导致CPU过载和内存不足。

**硬约束条件**

我们一起根据需要，定义了一种新的调度器：不再随机选择服务器；要能约束运行所需的资源分配，理想情况下，还要易于部署。

幸运的是，Docker Swarm拥有了全部这些特性，最近该工具的稳定性也已满足生产环境的要求。我们使用spread调度策略，以减少因服务器故障而损坏的容器数量。并设置了基于镜像的类别关系，同类容器可以运行在同样的服务器中。

我们使用了Datadog中Docker集成功能，可详细观测容器使用资源的情况。Datadog包含了所有我们需要的数据，可用来描述每个容器的内存或CPU使用率，以及每个服务器的磁盘使用率。

有了这份数据，我们发现内存是制约因素（不是CPU或磁盘），因此，我们决定利用内存约束来调度我们的容器。我们根据观测到的Datalog内存分配情况，设置我们的内存约束在99％的位置即1GB。我们还可以手动重置对每一个容器的约束。结果显示，这个约束非常有效！我们将不会再看到服务器内存不足，或因超载而运行缓慢。

**软约束条件**

享受了这个发现所带来的稳定性，在一段时间后，我们注意到，这种策略过度占用了服务器资源。大多数容器实际的内存使用率远远低于该内存硬约束1GB。这意味着我们所付费的比实际使用的多很多。

我们想要更经济高效，但又不能损失稳定性。降低硬约束不是一个好的选择，因为耗内存的应用会因为这个约束而崩溃。

我们需要一种基于估计的约束，在必要时又可以被突破的调度方法。值得庆幸的是，Docker提供了--memory-reservation选项来设置内存软约束。当设置该软约束时，容器可以自由地使用所需的内存，但是，当服务器上有内存争用时，Docker会试图缩减内存到软约束值以内。基于软约束的调度会减少浪费，并设置一个硬约束来阻止失控。但Swarm没有这个功能，所以是时候需要我们使用Go语言，给Swarm建立一个定制版本分支，可调度软内存约束，而不是硬约束。再使用Datadog收集数据，基于概率选择理想的软约束阀值，并设置硬约束为容器使用的最大值。这个方法显著地减少了浪费，而且也没有影响到稳定。

**动态范围和突破**

Docker1.12.0版中，最酷的一个功能是调度软约束的能力。虽然它仍等待发布，不过我们已经提前尝试，可简便地使用如下命令来调度软约束。

```sh
docker service create --reserve-memory <SOFT_LIMIT>
```

鉴于软约束的成功，我们的下一步是为每个容器动态地选择软约束和硬约束。因为所有的数据都输送到了Datadog，可通过一个查询，得到理想的软硬约束阈值，保持容器稳定运行而又不浪费资源[2]。

### 架构模式/设计模式

#### Swarm架构

Swarm作为一个管理Docker集群的工具，首先需要将其部署起来，可以单独将Swarm部署于一个节点。另外，自然需要一个Docker集群，集群上每一个节点均安装有Docker。具体的Swarm架构图可以参照下图： ![swarmarchitecture](/Users/pengqinglan/Documents/go_workspace/src/github.com/pengqinglan/note/img/swarmarchitecture.jpg)

Swarm架构中最主要的处理部分自然是Swarm节点，Swarm管理的对象自然是Docker Cluster，Docker Cluster由多个Docker Node组成，而负责给Swarm发送请求的是Docker Client[3]。

- Swarm对外提供两种API， 一种是Docker API，用于负责容器镜像的生命周期管理， 另外一种是Swarm集群管理CLI，用于集群管理。
- Scheduler模块，主要实现调度功能。在通过Swarm创建容器时，会经过Scheduler模块选择出一个最优节点，里面包含了两个子模块，分别是Filter和Strategy， Filter用来过滤节点，找出满足条件的节点（比如资源足够，节点正常等等），Strategy用来在过滤出的节点中根据策略选择一个最优的节点（比如对找出的节点进行对比，找到资源最多的节点等等）, 当然Filter/Strategy用户可以定制。
- Swarm对集群进行了抽象，抽象出了Cluster API，Swarm支持两种集群，一种是Swarm自身的集群，另外一种基于Mesos的集群。
- LeaderShip模块用于Swarm Manager自身的HA，通过主备方式实现。
- Discovery Service 服务发现模块，这个模块主要用来提供节点发现功能。
- 在每一个节点上，都会有一个Agent，用于连接Discovery Service，上报Docker Daemon的IP端口信息，Swarm Manager会直接从服务发现模块中读取节点信息[1]。

### 模块设计/接口设计

#### swarm create

Swarm中swarm create命令用于创建一个集群标志，用于Swarm管理Docker集群时，Docker Node的节点发现功能。

发起该命令之后，Swarm会前往Docker Hub上内建的发现服务中获取一个全球唯一的token，用以唯一的标识Swarm管理的Docker集群。

注：Swarm的运行需要使用服务发现，目前该服务内建与Docker Hub，该服务发现机制目前还在alpha版本，站点为：http://discovery-stage.hub/docker.com 。

#### swarm manage

Swarm中swarm manage是最为重要的管理命令。一旦swarm manage命令在Swarm节点上被触发，则说明用户需要swarm开始管理Docker集群。从运行流程的角度来讲，swarm经历的阶段主要有两点：启动swarm、接收并处理Docker集群管理请求。

Swarm启动的过程包含三个步骤：

1. 发现Docker集群中的各个节点，收集节点状态、角色信息，并监视节点状态的变化；
2. 初始化内部调度（scheduler）模块；
3. 创建并启动API监听服务模块；

**第一个步骤**，Swarm发现Docker集群中的节点。发现（discovery）是Swarm中用于维护Docker集群状态的机制。既然涉及到发现（discovery），那在这之前必须先有注册（register）。Swarm中有专门负责发现（discovery）的模块，而关于注册（register）部分，不同的discovery模式下，注册（register）也会有不同的形式。

目前，Swarm中提供了5种不同的发现（discovery）机制：Node Discovery、File Discovery、Consul Discovery、EtcD Discovery和Zookeeper Discovery。

**第二个步骤**，Swarm内部的调度（scheduler）模块被初始化。swarm通过发现机制发现所有注册的Docker Node，并收集到所有Docker Node的状态以及具体信息。此后，一旦Swarm接收到具体的Docker管理请求，Swarm需要对请求进行处理，并通过所有Docker Node的状态以及具体信息，来筛选（filter）决策到底哪些Docker Node满足要求，并通过一定的策略（strategy）将请求转发至具体的一个Docker Node。

**第三个步骤**，Swarm创建并初始化API监听服务模块。从功能的角度来讲，可以将该模块抽象为Swarm Server。需要说明的是：虽然Swarm Server完全兼容Docker的API，但是有不少Docker的命令目前是不支持的，毕竟管理Docker集群与管理单独的Docker会有一些区别。当Swarm Server被初始化并完成监听之后，用户即可以通过Docker Client向Swarm发送Docker集群的管理请求。

Swarm的swarm manage接收并处理Docker集群的管理请求，即是Swarm内部多个模块协同合作的结果。请求入口为Swarm Server，处理引擎为Scheduler，节点信息依靠Disocovery。

#### swarm join

Swarm的swarm join命令用于将Docker Node添加至Swarm管理的Docker集群中。从这点也可以看出swarm join命令的执行位于Docker Node，因此在Docker Node上运行该命令，首先需要在Docker Node上安装Swarm，由于该Swarm只会执行swarm join命令，故可以将其当成Docker Node上用于注册的agent模块。

功能而言，swarm join可以认为是完成Docker Node在Swarm节点处的注册（register）工作，以便Swarm在执行swarm manage时可以发现该Docker Node。然而，上文提及的5种discovery模式中，并非每种模式都支持swarm join命令。不支持的discovery的模式有Node Discovery与File Discovery。

Docker Node上swarm join执行之后，标志着Docker Node向Swarm注册，请求加入Swarm管理的Docker集群中。Swarm通过注册信息，发现Docker Node，并获取Docker Node的状态以及具体信息，以便处理Docker请求时作为调度依据。

#### swarm list

Swarm中的swarm list命令用以列举Docker集群中的Docker Node。

Docker Node的信息均来源于Swarm节点上注册的Docker Node。而一个Docker Node在Swarm节点上注册，仅仅是注册了Docker Node的IP地址以及Docker监听的端口号。

使用swarm list命令时，需要指定discovery的类型，类型包括：token、etcd、file、zk以及<ip>。而swarm list并未罗列Docker集群的动态信息，比如Docker Node真实的运行状态，或者Docker Node在Docker集群中扮演的角色信息[3]。

### 关键流程时序图



## 详细设计

### 集群管理模块

Swarm Manager CLI用于集群管理。通过三步就可以将集群创建起来。

```sh
$ swarm create
$ swarm join --add=<node_ip> token://<token>
$ swarm manage -H=<manage_ip> token://<token>
```

Swarm容器集群创建完成后，就可以采用Docker命令，像使用Docker Engine一样使用Swarm集群创建容器了[1]。

### 服务发现模块

服务发现，在Swarm中主要用于节点发现，每一个节点上的Agent会将docker-egine的IP端口注册到服务发现系统中。Manager会从服务发现模块中读取节点信息。Swarm中服务发现支持已下3种类型的后端：

1. hosted discovery service，是Docker Hub提供的服务发现服务，需要连接外网访问。
2. KV分布式存储系统，现在已支持etcd、ZooKeeper、Consul三种。
3. 静态IP，可以使用本地文件或者直接指定节点IP，这种方式不需要启动额外使用其他组件,一般在调试中会使用到[1]。

### Scheduler

调度模块主要用户容器创建时，选择一个最优节点。在选择最优节点过程中，分为了两个阶段：
第一个阶段，是过滤。根据条件过滤出符合要求的节点，过滤器有以下5种：

1. Constraints，约束过滤器，可以根据当前操作系统类型、内核版本、存储类型等条件进行过滤，当然也可以自定义约束，在启动Daemon的时候，通过Label来指定当前主机所具有的特点。
2. Affnity，亲和性过滤器，支持容器亲和性和镜像亲和性，比如一个web应用，我想将DB容器和Web容器放在一起，就可以通过这个过滤器来实现。
3. Dependency，依赖过滤器。如果在创建容器的时候使用了–volume-from/–link/–net某个容器，则创建的容器会和依赖的容器在同一个节点上。
4. Health filter，会根据节点状态进行过滤，会去除故障节点。
5. Ports filter，会根据端口的使用情况过滤。

调度的第二个阶段是根据策略选择一个最优节点。有以下三种策略：

1. Binpack，在同等条件下，选择资源使用最多的节点，通过这一个策略，可以将容器聚集起来。
2. Spread，在同等条件下，选择资源使用最少的节点，通过这一个策略，可以将容器均匀分布在每一个节点上。
3. Random，随机选择一个节点[1]。

### Leadership

Leadership模块，这个模块主要用来提供Swarm Manager自身的HA。

为了防止Swarm Manager单点故障，引入了HA机制，Swarm Manager自身是无状态的，所以还是很容易实现HA的。 实现过程中采用主备方式，当主节点故障以后，会从新选主提供服务，选主过程中采用分布式锁实现，现在支持etcd、ZooKeeper、Consul三种类型的分布式存储，用来提供分布式锁。 当备节点收到消息后，会将消息转发给主节点[1]。

## 参考文献

[1] 线超博. DockOne技术分享（二十）：Docker三剑客之Swarm介绍[EB/OL]. http://dockone.io/article/662 . 2015-09-8.

[2] 陈晏娥. Docker Swarm：经济高效的容器调度[EB/OL]. http://dockone.io/article/1630 . 2016-08-17.

[3] 孙宏亮. 深入浅出Swarm[EB/OL]. http://blog.daocloud.io/swarm_analysis_part1/ . 2015-01-25.

