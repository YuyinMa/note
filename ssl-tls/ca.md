来源：https://en.wikipedia.org/wiki/Certificate_authority

### CA

在全球范围内，认证机构业务分散，国家或地区提供商主导其国内市场。 这是因为数字证书的许多使用，例如具有法律约束力的数字签名，与证书机构的当地法律，法规和认证计划相关联。

然而，全球受信任的X.509证书（一种用于传输层安全的证书）的市场主要由少数跨国公司持有。 由于技术要求，这个市场有很大的进入障碍。虽然没有法律要求，新的提供商可以选择进行年度安全审计（如北美证书颁发机构的WebTrust 和欧洲的ETSI ），以包括在网络浏览器可信机构列表中。 超过50个根证书在最受欢迎的Web浏览器版本中受信任。

根据2015年5月的NetCraft，监控活动TLS证书的行业标准，指出"尽管全球[TLS]生态系统具有竞争力，但它主要由少数主要CA - 三个证书颁发机构（赛门铁克，Comodo，GoDaddy）帐户 在面向公众的网络服务器上发布的所有[TLS]证书中的四分之三，自从[我们的]调查开始以来，赛门铁克（或VeriSign在赛门铁克收购之前）已经举办了这一排名， 为了说明不同方法的影响，在百万个最繁忙的网站中，赛门铁克发布了44％的有效可信证书，远远超过其整体市场份额。

### 2016市场份额

| Rank | Issuer                                   | Usage  | Market share |
| ---- | ---------------------------------------- | ------ | ------------ |
| 1    | [Comodo](https://en.wikipedia.org/wiki/Comodo_Group) | 8.1%   | 40.6%        |
| 2    | [Symantec](https://en.wikipedia.org/wiki/Symantec) | 5.2%   | 26.0%        |
| 3    | [GoDaddy](https://en.wikipedia.org/wiki/GoDaddy) | 2.4%   | 11.8%        |
| 4    | [GlobalSign](https://en.wikipedia.org/wiki/GlobalSign) | 1.9%   | 9.7%         |
| 5    | [IdenTrust](https://en.wikipedia.org/wiki/IdenTrust) | 0.7%   | 3.5%         |
| 6    | [DigiCert](https://en.wikipedia.org/wiki/DigiCert) | 0.6%   | 3.0%         |
| 7    | [StartCom](https://en.wikipedia.org/wiki/StartCom) | 0.4%   | 2.1%         |
| 8    | [Entrust](https://en.wikipedia.org/wiki/Entrust) | 0.1%   | 0.7%         |
| 9    | [Trustwave](https://en.wikipedia.org/wiki/Trustwave_Holdings) | 0.1%   | 0.5%         |
| 10   | [Verizon](https://en.wikipedia.org/wiki/Verizon_Communications) | 0.1%   | 0.5%         |
| 11   | [Secom](https://en.wikipedia.org/wiki/Secom) | 0.1%   | 0.5%         |
| 12   | Unizeto                                  | 0.1%   | 0.4%         |
| 13   | [QuoVadis](https://en.wikipedia.org/wiki/QuoVadis) | < 0.1% | 0.1%         |
| 14   | [Deutsche Telekom](https://en.wikipedia.org/wiki/Deutsche_Telekom) | < 0.1% | 0.1%         |
| 15   | [Network Solutions](https://en.wikipedia.org/wiki/Network_Solutions) | < 0.1% | 0.1%         |
| 16   | TWCA                                     | < 0.1% | 0.1%         |

### 举例

公钥密码术可以用于加密在双方之间传送的数据。 当用户登录到实现HTTP安全协议的任何站点时，通常都会发生这种情况。 在这个例子中，让我们假设用户登录到他们的银行主页www.bank.example做网上银行。 当用户打开www.bank.example首页时，他们会收到一个公钥以及其Web浏览器显示的所有数据。 公钥可以用于加密从客户端到服务器的数据，但安全的过程是在确定临时共享对称加密密钥的协议中使用它; 这样的密钥交换协议中的消息可以用银行的公钥加密，使得只有银行服务器具有用于读取它们的私钥。

其余的通信然后使用新的（一次性）对称密钥进行，因此当用户向银行的页面输入一些信息并提交页面（将信息发送回银行）时，用户已经输入到页面的数据将被他们的网络浏览器加密。 因此，即使有人可以访问从用户传送到www.bank.example的（加密的）数据，这样的窃听者也不能读取或解密它。

这种机制只有在用户可以确定它是他们在网络浏览器中看到的银行时才是安全的。 如果用户键入www.bank.example，但他们的通信是高密度的，假的网站（假装是银行网站）将页面信息发送回用户的浏览器，假网页 可以向用户发送假公钥（假冒网站拥有匹配的私钥）。 用户将填写表单的个人数据，并提交页面。 然后，伪造的网页将访问用户的数据。

这是证书授权机制旨在防止的。 证书机构（CA）是存储公钥及其所有者的组织，通信中的每一方都信任该组织（并且知道其公钥）。 当用户的web浏览器从www.bank.example接收公共密钥时，它还接收密钥的数字签名（具有一些更多的信息，在所谓的X.509证书中）。 浏览器已经拥有CA的公钥，因此可以验证签名，信任证书和其中的公钥：因为www.bank.example使用认证机构认证的公钥，伪造的www.bank.example 只能使用相同的公钥。 由于伪www.bank.example不知道对应的私钥，它不能创建验证其真实性所需的签名。

### 

