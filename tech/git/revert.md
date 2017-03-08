以提问中修改了两个文件a、b为例，假设需要撤销文件a的修改，则修改后的两个文件：
1、如果没有被git add到索引区
git checkout a 便可撤销对文件a的修改

2、如果被git add到索引区，但没有做git commit提交
1）使用git reset将a从索引区移除（但会保留在工作区）
git reset HEAD a
2）撤销工作区中文件a的修改
git checkout a 

3、如果已被提交，则需要先回退当前提交到工作区，然后撤销文件a的修改
1）回退当前提交到工作区
git reset HEAD^
2）撤销工作区中文件a的修改
git checkout a 

补充：灵活使用以上操作的关键在于理解git中工作区、索引区的概念和git reset命令hard、mixed(default)、soft三种模式的区别，网上有很多这方面的文章，不再赘述。

作者：佛陀小沙弥
链接：https://www.zhihu.com/question/20039839/answer/125382988
来源：知乎
著作权归作者所有，转载请联系作者获得授权。

