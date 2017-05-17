### 从 java 类到 WSDL 文件

```Shell
$ ls
org

$ wsgen -cp . org.javaee7.jaxws.endpoint.EBookStoreImpl -wsdl

$ ls
EBookStoreImplService.wsdl        org
EBookStoreImplService_schema1.xsd
```

### 从 WSDL 文件到 java 类

```Shell
$ ls                                  
EBookStoreImplService.wsdl        org
EBookStoreImplService_schema1.xsd

$ wsimport -d generated EBookStoreImplService.wsdl -Xnocompile
parsing WSDL...
Generating code...

$ ls generated/org/javaee7/jaxws/endpoint/
AddAppendix.java            SaveBook.java
AddAppendixResponse.java    SaveBookResponse.java
EBook.java                  TakeBook.java
EBookStore.java             TakeBookResponse.java
EBookStoreImplService.java  WelcomeMessage.java
FindEBooks.java             WelcomeMessageResponse.java
FindEBooksResponse.java     package-info.java
ObjectFactory.java


```

### 从 WSDL 文件到 class 文件

```Shell
$ ls
EBookStoreImplService.wsdl        generated
EBookStoreImplService_schema1.xsd org

$ wsimport -d generated EBookStoreImplService.wsdl            
parsing WSDL...
Generating code...
Compiling code...

$ ls generated/org/javaee7/jaxws/endpoint/
AddAppendix.class            SaveBook.class
AddAppendixResponse.class    SaveBookResponse.class
EBook.class                  TakeBook.class
EBookStore.class             TakeBookResponse.class
EBookStoreImplService.class  WelcomeMessage.class
FindEBooks.class             WelcomeMessageResponse.class
FindEBooksResponse.class     package-info.class
ObjectFactory.class
```