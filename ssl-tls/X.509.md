来源：https://en.wikipedia.org/wiki/X.509

### 什么是X.509

在密码学中，X.509是公钥基础设施（PKI）管理数字证书和公钥加密的重要标准，也是用于保护网络和电子邮件通信的传输层安全协议的关键部分 。 ITU-T标准X.509规定了公钥证书，证书撤销列表，属性证明和证书路径验证算法的格式。

### X.509过程

1. 在X.509系统中，希望签名证书的组织通过证书签名请求（CSR）请求一个证书。
2. 为此，他们首先生成一个密钥对，保持私钥的秘密，并使用它来签署CSR。它包含标识申请人和申请人的公钥的信息，该公钥用于验证CSR的签名和可分辨名称（DN），即证书的完全限定域名。 CSR可以伴随有认证机构所要求的其他凭证或身份证明。
3. 证书颁发机构颁发将公钥绑定到特定专有名称的证书。
4. 组织的受信任的根证书可以分发给所有员工，以便他们可以使用公司的PKI系统。浏览器如Internet Explorer，Firefox，Opera，Safari和Chrome都预先安装了一组预定的根证书，所以来自较大供应商的SSL证书将立即工作;实际上浏览器的开发人员确定哪些CA是浏览器用户的受信任的第三方。
5. X.509还包括证书吊销列表（CRL）实现的标准，这是PKI系统常常被忽视的方面。 IETF批准的检查证书有效性的方式是在线证书状态协议（OCSP）。 

### X.509规定了证书的格式

X.509 v3数字证书的结构如下：

- Certificate
  - Version Number
  - Serial Number
  - Signature Algorithm ID
  - Issuer Name
  - Validity period
    - Not Before
    - Not After
  - Subject name
  - Subject Public Key Info
    - Public Key Algorithm
    - Subject Public Key
  - Issuer Unique Identifier (optional)
  - Subject Unique Identifier (optional)
  - Extensions (optional)
    - ...
- Certificate Signature Algorithm
- Certificate Signature


### 一个X.509例子

这是一个使用OpenSSL生成的www.freesoft.org的解码X.509证书的例子，实际证书的大小约为1 kB。 它由Thawte发布 - 自VeriSign收购并现在由Symantec拥有，如发行人字段中所述。 它的主题包含许多个人详细信息，但最重要的部分通常是通用名称（CN），因为这是必须与要验证的主机匹配的部分。 还包括RSA公钥（模数和公共指数），随后是签名，通过获取证书的第一部分的MD5哈希并使用Thawte的RSA私钥对其签名（应用加密操作）来计算。

```
$ openssl x509 -in freesoft-certificate.pem -noout -text
Certificate:
   Data:
       Version: 1 (0x0)
       Serial Number: 7829 (0x1e95)
       Signature Algorithm: md5WithRSAEncryption
       Issuer: C=ZA, ST=Western Cape, L=Cape Town, O=Thawte Consulting cc,
               OU=Certification Services Division,
               CN=Thawte Server CA/emailAddress=server-certs@thawte.com
       Validity   
           Not Before: Jul  9 16:04:02 1998 GMT
           Not After : Jul  9 16:04:02 1999 GMT
       Subject: C=US, ST=Maryland, L=Pasadena, O=Brent Baccala,
                OU=FreeSoft, CN=www.freesoft.org/emailAddress=baccala@freesoft.org
       Subject Public Key Info:
           Public Key Algorithm: rsaEncryption
           RSA Public Key: (1024 bit)
               Modulus (1024 bit):
                   00:b4:31:98:0a:c4:bc:62:c1:88:aa:dc:b0:c8:bb:
                   33:35:19:d5:0c:64:b9:3d:41:b2:96:fc:f3:31:e1:
                   66:36:d0:8e:56:12:44:ba:75:eb:e8:1c:9c:5b:66:
                   70:33:52:14:c9:ec:4f:91:51:70:39:de:53:85:17:
                   16:94:6e:ee:f4:d5:6f:d5:ca:b3:47:5e:1b:0c:7b:
                   c5:cc:2b:6b:c1:90:c3:16:31:0d:bf:7a:c7:47:77:
                   8f:a0:21:c7:4c:d0:16:65:00:c1:0f:d7:b8:80:e3:
                   d2:75:6b:c1:ea:9e:5c:5c:ea:7d:c1:a1:10:bc:b8:
                   e8:35:1c:9e:27:52:7e:41:8f
               Exponent: 65537 (0x10001)
   Signature Algorithm: md5WithRSAEncryption
       93:5f:8f:5f:c5:af:bf:0a:ab:a5:6d:fb:24:5f:b6:59:5d:9d:
       92:2e:4a:1b:8b:ac:7d:99:17:5d:cd:19:f6:ad:ef:63:2f:92:
       ab:2f:4b:cf:0a:13:90:ee:2c:0e:43:03:be:f6:ea:8e:9c:67:
       d0:a2:40:03:f7:ef:6a:15:09:79:a9:46:ed:b7:16:1b:41:72:
       0d:19:aa:ad:dd:9a:df:ab:97:50:65:f5:5e:85:a6:ef:19:d1:
       5a:de:9d:ea:63:cd:cb:cc:6d:5d:01:85:b5:6d:c8:f3:d9:f7:
       8f:0e:fc:ba:1f:34:e9:96:6e:6c:cf:f2:ef:9b:bf:de:b5:22:
       68:9f
```

这是一个自签名证书的例子，因为发行者和主题相同。 没有办法验证此证书，除非通过检查它自己，相反，这些顶级证书由Web浏览器手动存储。 Thawte是Microsoft和Netscape认可的根证书颁发机构之一。 此证书随附Web浏览器，默认受信任。 作为一个长期的，全球受信任的证书，可以签署任何东西（因为在X509v3基本约束部分没有约束），其匹配的私钥必须被严密保护。

### 证书链和交叉认证

证书链（见RFC 5280定义的“认证路径”的等价概念）是一个证书列表（通常以最终实体证书开头），后跟一个或多个CA证书（通常最后一个是 自签名证书），具有以下属性：

1. 每个证书（除了最后一个证书）的颁发者与列表中下一个证书的主题相匹配。
2. 每个证书（最后一个证书除外）应该由与链中下一个证书相对应的密钥签署（即，一个证书的签名可以使用包含在以下证书中的公钥来验证）。
3. 列表中的最后一个证书是信任锚：您信任的证书，因为它是通过一些可信的过程传递给您的。

使用证书链以便检查包含在目标证书（链中的第一个证书）中的公钥（PK）和其中包含的其他数据实际上属于其主题。 为了确定这一点，通过使用包括在以下证书中的PK来验证目标证书上的签名，其签名使用下一个证书来验证，等等，直到达到链中的最后一个证书。 由于最后一个证书是信任锚，成功到达它将证明目标证书可以被信任。