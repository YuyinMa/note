### SOA 与 Web Service

 SOA(Service-Oriented Architecture)面向服务架构是一种思想，它将应用程序的不同功能单元通过中立的契约（独立于硬件平台、操作系统和编程语言）联系起来，使得各种形式的功能单元更好的集成。

目前来说，WebService 是SOA 的一种较好的实现方WebService 采用HTTP 作为传输协议，SOAP（Simple Object Access Protocol）作为传输消息的格式。但WebService 并不是完全符合SOA 的概念，因为SOAP 协议是WebService 的特有协议，并未符合SOA 的传输协议透明化的要求。SOAP 是一种应用协议，早期应用于RPC 的实现，传输协议可以依赖于HTTP、SMTP 等。

### Java 中的 Web Service

JAVA 中共有三种WebService 规范，分别是 JAXM&SAAJ、JAX-WS（JAX-RPC）、JAX-RS。
下面来分别简要的介绍一下这三个规范。

1. **JAX-WS：**

JAX-WS（Java API For XML-WebService），JDK1.6 自带的版本为JAX-WS2.1，其底层支
持为JAXB。早期的基于SOAP 的JAVA 的Web 服务规范JAX-RPC（Java API For
XML-Remote Procedure Call）目前已经被JAX-WS 规范取代，JAX-WS 是JAX-RPC 的演进
版本，但JAX-WS 并不完全向后兼容JAX-RPC，二者最大的区别就是RPC/encoded 样式的
WSDL，JAX-WS 已经不提供这种支持。JAX-RPC 的API 从JAVA EE5 开始已经移除，如
果你使用J2EE1.4，其API 位于javax.xml.rpc.*包。
JAX-WS（JSR 224）规范的API 位于javax.xml.ws.*包，其中大部分都是注解，提供API 操
作Web 服务（通常在客户端使用的较多，由于客户端可以借助SDK 生成，因此这个包中的
API 我们较少会直接使用）。
WS-MetaData（JSR 181）是JAX-WS 的依赖规范，其API 位于javax.jws.*包，使用注解配
置公开的Web 服务的相关信息和配置SOAP 消息的相关信息。

2. **JAXM&SAAJ：**

JAXM（JAVA API For XML Message）主要定义了包含了发送和接收消息所需的API，相当
于Web 服务的服务器端，其API 位于javax.messaging.*包，它是Java EE 的可选包，因此
你需要单独下载。
SAAJ（SOAP With Attachment API For Java，JSR 67）是与JAXM 搭配使用的API，为构建
SOAP 包和解析SOAP 包提供了重要的支持，支持附件传输，它在服务器端、客户端都需要
使用。这里还要提到的是SAAJ 规范，其API 位于javax.xml.soap.*包。
JAXM&SAAJ 与JAX-WS 都是基于SOAP 的Web 服务，相比之下JAXM&SAAJ 暴漏了SOAP
更多的底层细节，编码比较麻烦，而JAX-WS 更加抽象，隐藏了更多的细节，更加面向对
象，实现起来你基本上不需要关心SOAP 的任何细节。那么如果你想控制SOAP 消息的更
多细节，可以使用JAXM&SAAJ，目前版本为1.3。

3. **JAX-RS：**

JAX-RS 是 JAVA 针对 REST(Representation State Transfer)风格制定的一套Web 服务规范，由于推出的较晚，该规范（JSR 311，目前JAX-RS 的版本为1.0）并未随JDK1.6 一起发行，你需要到 JCP 上单独下载 JAX-RS 规范的接口，其API 位于javax.ws.rs.*包。
这里的 JAX-WS 和 JAX-RS 规范我们采用Apache CXF 作为实现，CXF 是Objectweb Celtix
和Codehaus XFire 合并而成。CXF 的核心是org.apache.cxf.Bus（总线），类似于spring 的ApplicationContext，Bus 由BusFactory 创建，默认是SpringBusFactory 类，可见默认CXF是依赖于Spring 的，Bus 都有一个ID，默认的BUS 的ID 是cxf。你要注意的是Apache CXF2.2 的发行包中的jar 你如果直接全部放到lib 目录，那么你必须使用JDK1.6，否则会报
JAX-WS 版本不一致的问题。对于JAXM&SAAJ 规范我们采用JDK 中自带的默认实现[1]。

### Web Service 规范

Web Service的规范包括基本规范(WSDL、SOAP、UDDI)以及扩展规范WS-*(WS-Security、WS-Policy、WS-Addressing、WS-Trust等)。

这些标准由这些组织制订：W3C负责XML、SOAP及WSDL；OASIS负责UDDI[2]。

The following is a list of web service protocols[2].

* BEEP - Blocks Extensible Exchange Protocol
* E-Business XML
* Hessian
* JSON-RPC
* JSON-WSP
* REST-compliant Web services
* SOAP - outgrowth of XML-RPC, originally an acronym for Simple Object Access Protocol
* Universal Description, Discovery, and Integration (UDDI)
* Web Processing Service (WPS)
* WSCL - Web Services Conversation Language
* WSFL - Web Services Flow Language (superseded by BPEL)
* XINS Standard Calling Convention - HTTP parameters in (GET/POST/HEAD), POX out
* XLANG - XLANG-Specification (superseded by BPEL)
* XML-RPC - XML Remote Procedure Call

###  

### 参考

[1] qiailin, http://blog.csdn.net/qiailin/article/details/6177064

[2] wikipedia, https://en.wikipedia.org/wiki/List_of_web_service_protocols