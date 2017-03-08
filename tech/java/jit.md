### 什么是JIT

在Java编程语言和环境中，即时编译器（JIT compiler，just-in-time compiler）是一个把Java的字节码（包括需要被解释的指令的程序）转换成可以直接发送给处理器的指令的程序。

当你写好一个Java程序后，源语言的语句将由Java编译器编译成字节码，而不是编译成与某个特定的处理器硬件平台对应的指令代码（比如，Intel的Pentium微处理器或IBM的System/390处理器）。

字节码是可以发送给任何平台并且能在那个平台上运行的独立于平台的代码[1]。

javac将程序源代码编译，转换成java字节码，JVM通过解释字节码将其翻译成对应的机器指令，逐条读入，逐条解释翻译。很显然，经过解释执行，其执行速度必然会比可执行的二进制字节码程序慢。为了提高执行速度，引入了JIT技术。

在运行时JIT会把翻译过的机器码保存起来，已备下次使用，因此从理论上来说，采用该JIT技术可以，可以接近以前纯编译技术[2]。

### JIT流程

当JIT编译启用时（默认是启用的），JVM读入.class文件解释后，将其发给JIT编译器。JIT编译器将字节码编译成本机机器代码。

![jit流程](https://github.com/pengqinglan/note/blob/master/img/jit.jpg)

由于JIT对每条字节码都进行编译，造成了编译过程负担过重。为了避免这种情况，当前的JIT只对经常执行的字节码进行编译，如循环等[2]。

### 参考

[1] 百度百科, http://baike.baidu.com/item/JIT%E7%BC%96%E8%AF%91%E5%99%A8

[2] clover, http://xlover.iteye.com/blog/1679653