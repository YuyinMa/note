### 从 java 类到 WSDL 文件

```Shell
$ ls
org

$ wsgen -cp . org.javaee7.jaxws.endpoint.EBookStoreImpl -wsdl

$ ls
EBookStoreImplService.wsdl        org
EBookStoreImplService_schema1.xsd
```

### 从 WSDL 文件到