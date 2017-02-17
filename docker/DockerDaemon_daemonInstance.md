### Docker Daemon Instance

Docker Daemon 实例包含一系列方法，来处理来自webserver的请求，是API的具体实现。

daemon/***.go 就是对API的具体实现

### Create new Docker Daemon Instance

```go
func NewDaemon(config *Config, registryService registry.Service, containerdRemote libcontainerd.Remote) (daemon *Daemon, err error) {
  ...
}
```

* Config：      cli参数配置
* registry.Service：      待安装到engine中的service
* libcontainerd.Remote：      libcontainerd remote实例