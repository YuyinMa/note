# server.go 流程

分析shadow socks-go/cmd/shadow-server/server.go中main函数

### 赋值flag 

1. 使用了go的flag包

### ParseConfig

1. 读取配置文件（如果使用了-c参数）
2. 检查加密方式

### CheckCipherMethod

1. 检测配置的加密方式是否受支持

### unifyPortPasswor

1. 检测端口和密码是否合法
2. 合法是密码非空，端口非0

### 运行监听一个端口的goroutine

1. 监听端口
2. 生成密码
3. 循环监听
4. 处理连接（分析重点handleConnection）

### waitSignal

1. 监听退出信号

# handleConnection

### 计算连接编号

### 拨号取得请求方句柄

### PipeThenClose