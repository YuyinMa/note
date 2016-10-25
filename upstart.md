# Upstart

### upstart 是一种 init 系统

### init 系统

1. 在内核就被加载进内存中运行会从根文件系统中加载一个所有程序的父进程init进程
2. init的历史很久远，早期Linux使用的init有两个版本：sysV和BSD。现在他们仍旧没有完全被废弃，现在还有不少发行版本采用这两个系统比如dibian还采用system V init，archlinux在2012年前后才放弃BSD init切换到systemd

BSD

* 使用/etc目录下以rc.x作为文件名的文件来描述init的操作
 - rc.sysinit
 - rc.single单用户执行
 - rc.multi2～5执行
 - rc.local是杂项
 - init系统会按照以上顺序加载运行
 - rc.conf包含了相关的配置


system V

*  脚本文件目录在`/etc/init.d/`
 - `/etc/rc{runlevel}.d`目录标识相应运行级别的目录
 - 目录下的文件以S开头的是启动的服务，以K开头的是不启动的服务
 - 启动标识后紧跟的数字表示启动优先级，数值越小运行越早
 - 通过service命令来起停服务
 - 通过chkconf来管理服务
 - 通过`/etc/inittab`文件来配置相应的运行级别


以上两种init系统加载的文件本身都是一些脚本文件，通过这些脚本可以加载相应的模块或者启动需要的程序。

### systemd

systemd 是 Linux 下的一款系统和服务管理器，兼容 SysV 和 LSB 的启动脚本，我们用 systemctl 来管理 systemd，同时也兼容 service 命令

* systemd支持并行化任务
* 同时采用 socket 式与 D-Bus 总线式激活服务
* 按需启动守护进程（daemon）
* 利用 Linux 的 cgroups 监视进程
* 支持快照和系统恢复
* 维护挂载点和自动挂载点
* 各服务间基于依赖关系进行精密控制。

### upstart
Ubuntu 使用了一种被称为 upstart 的新型 init 系统，我们使用使用initctl 来管理 upstart

1. 桌面系统或便携式设备的一个特点是经常重启，而且要频繁地使用硬件热插拔技术
2. 针对以上种种情况，Ubuntu 开发人员在评估了当时的几个可选 init 系统之后，决定重新设计和开发一个全新的 init 系统，即 UpStart
3. UpStart 基于事件机制，比如 U 盘插入 USB 接口后，udev 得到内核通知，发现该设备

### Upstart 特点
采用事件驱动模型，UpStart 解决了之前提到的 sysvinit 的缺点UpStart 可以

* 更快地启动系统
* 当新硬件被发现时动态启动服务
* 硬件被拔除时动态停止服务
* 这些特点使得 UpStart 可以很好地应用在桌面或者便携式系统中，处理这些系统中的动态硬件插拔特性。


# Upstart 概念和术语

### UpStart 主要的概念是 job 和 event

### job
Job 就是一个工作单元，用来完成一件工作，比如启动一个后台服务，或者运行一个配置命令。每个 Job 都等待一个或多个事件，一旦事件发生，upstart 就触发该 job 完成相应的工作。

有三种类型的工作


1. **task job** 代表在一定时间内会执行完毕的任务，比如删除一个文件
2. **service job** 代表后台服务进程，比如 apache httpd。这里进程一般不会退出，一旦开始运行就成为一个后台守护进程，由 init 进程管理，如果这类进程退出，由 init 进程重新启动，它们只能由 init 进程发送信号停止。它们的停止一般也是由于所依赖的停止事件而触发的，不过 upstart 也提供命令行工具，让管理人员手动停止某个服务
3. **Abstract job** 仅由 upstart 内部使用，仅对理解 upstart 内部机理有所帮助。我们不用关心它。

除了以的分类之外，还有另一种工作（Job）分类方法。Upstart 不仅可以用来为整个系统的初始化服务，也可以为每个用户会话（session）的初始化服务。系统的初始化任务就叫做 system job，比如挂载文件系统的任务就是一个 system job；用户会话的初始化服务就叫做 session job。


### Upstart 中 Job 的可能状态

    Waiting	    初始状态
    Starting	Job 即将开始
    pre-start	执行 pre-start 段，即任务开始前应该完成的工作
    Spawned	准备执行 script 或者 exec 段
    post-start	执行 post-start 动作
    Running	interim state set after post-start section     processed denoting job is running (But it may have no associated PID!)
    pre-stop	执行 pre-stop 段
    Stopping	interim state set after pre-stop section         processed
    Killed	    任务即将被停止
    post-stop	执行 post-stop 段
    
    
其中有四个状态会引起 init 进程发送相应的事件，表明该工作的相应变化：

* Starting
* Started
* Stopping
* Stopped

而其它的状态变化不会发出事件

### 事件 Event
事件在 upstart 中以通知消息的形式具体存在。一旦某个事件发生了，Upstart 就向整个系统发送一个消息。没有任何手段阻止事件消息被 upstart 的其它部分知晓，事件一旦发生，整个 upstart 系统中所有工作和其它的事件都会得到通知
Event 可以分为三类: signal，methods 或者 hooks

1. **Signal** 事件是非阻塞的，异步的。发送一个信号之后控制权立即返回。
2. **Methods** 事件是阻塞的，同步的。
3. **Hooks** 事件是阻塞的，同步的。它介于 Signals 和 Methods 之间，调用发出 Hooks 事件的进程必须等待事件完成才可以得到控制权，但不检查事件是否成功。


# Ubuntu 中的 upstart
1. 从 Ubuntu 15.04 开始，Ubuntu 开始逐步使用 Systemd 替代 Upstart 初始化系统
2. Ubuntu is the latest Linux distribution to switch to systemd.
3. On Ubuntu 16.04, systemd supplants Canonical's Upstart.

# 查看 upstart 日志
1. 重启 kubelet 服务
        
        $ service kubelet restart
        
        kubelet stop/waiting
        kubelet start/running, process 29101
2. 查看 upstart 日志

        $ tail -n 10 /var/log/upstart/kubelet.log
        
        I1014 10:57:00.055359   29508 factory.go:228] Registering Docker factory        
        E1014 10:57:00.055509   29508 manager.go:240] Registration of the rkt container factory failed: unable to communicate with Rkt api service: rkt: cannot tcp Dial rkt api service: dial tcp [::1]:15441: getsockopt: connection refused
        I1014 10:57:00.055583   29508 factory.go:54] Registering systemd factory
        I1014 10:57:00.057861   29508 factory.go:86] Registering Raw factory
        I1014 10:57:00.060040   29508 manager.go:1072] Started watching for new ooms in manager
        I1014 10:57:00.060401   29508 oomparser.go:200] OOM parser using kernel log file: "/var/log/kern.log"
        I1014 10:57:00.062845   29508 manager.go:281] Starting recovery of all containers
        I1014 10:57:00.148945   29508 manager.go:286] Recovery completed







# 参考

* <http://www.ibm.com/developerworks/cn/linux/1407_liuming_init2/>(upstart)
* <http://blog.csdn.net/cnsword/article/details/42272505>(init系统)
* <https://www.digitalocean.com/community/tutorials/what-s-new-in-ubuntu-16-04>(ubuntu 16.04 新特性)























