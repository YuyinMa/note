### 权限查看

```sh
$ ls -l
-rw-r--r--@ 1 pengqinglan  staff    36 Feb  5 21:24 chmod.md
-rw-r--r--  1 pengqinglan  staff   194 Jan  4 15:37 echo-eof.md
-rw-r--r--@ 1 pengqinglan  staff   104 Jan  8 16:08 finder-mac.md
```

`ls -l`指令显示当前文件夹下每个文件、文件夹的详细信息，依次为

* 文件权限信息
* 链接数量
* 文件所有者
* 所有者的用户组
* 文件的字节（byte=8位）数
* 文件最近修改时间
* 文件名

如果文件有扩展属性，就会在权限字段后面多一个`@`

如果文件有扩展的安全信息（例如权限控制列表），就会多一个 `+`

### 三组权限

三组权限依次为：文件所有者、用户组、其他人

三种权限分别是：r（读）、w（写）、x（执行）

三组权限并列为：

```            775
-rwx-rwx-rwx   -rw--rw--rw-   -rwx-rwx-r-x   -rw--rw--r--
-111-111-111   -110-110-110   -111-111-101   -110-110-100
777            666            775            664
```

### 改变权限

使用chmod来改变文件权限

```sh
# 递归文件夹赋权限
$ chmod -R
```

### 参考

[1] MacOS下 `man ls`，The Long Format