### 介绍

docker是一个典型的C/S架构程序（也可扩展成B/S）

### 目录结构

cmd、client、cli构成了客户端，包含：

* client定义了API接口，并进行的http请求封装实现


* cli封装command和flag，定义交互，远程调用API
* cmd是客户端的入口，注册并触发执行command

版本：1.14.0

| 目录            | 介绍                               |
| ------------- | -------------------------------- |
| cmd           | 客户端入口，注册并执行命令                    |
| cli           | 根据API完整定义了command与flag，用于在cmd中注册 |
| client        | 定义了Client API接口，并进行实现（HTTP请求包装）       |
| api           | Daemon API定义，定义路由和注册handle       |
| daemon        | Daemon API的具体实现                  |
| container     |                                  |
| plugin        |                                  |
| libcontainerd |                                  |
| hack          |                                  |

### 程序入口

#### [Docker Daemon](https://github.com/pengqinglan/note/blob/master/docker/DockerDaemon.md)

Docker Deamon只有一个主command，并有多个flag

1. cmd/dockerd/docker.go 注册flag

   ```
   opts.common.InstallFlags(flags)
   ```

2. cmd/dockerd/docker.go 执行command

   ```
   runDaemon(opts)
   ```

3. cmd/dockerd/docker.go 实例化daemonCli并start service

   ```
   daemonCli.start(opts)
   ```

#### [Docker Client](https://github.com/pengqinglan/note/blob/master/docker/DockerClient.md)

1. client/interface.go 定义API接口

2. cli/command/类型/操作.go 封装，调用API

   ```
   client.NetworkConnect(context.Background(), opts.network, opts.container, epConfig)
   ```


3. cmd/docker/docker.go 注册commands

   ```
   commands.AddCommands(cmd, dockerCli)
   ```

4. cmd/docker/docker.go 连接Docker daemon，生成client对象

   ```
   dockerCli.Initialize(opts)
   ```

5. cmd/docker/docker/go 执行command

   ```
   cmd.Execute()
   ```
