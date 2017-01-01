### main
dockerd 没有command
cobra 收集flag
dockerd 指令执行 runDaemon 方法
runDaemon 方法中实例化 daemonCli 对象并运行
```go
err = daemonCli.start(opts)
```

### DaemonCli
```go
// DaemonCli represents the daemon CLI.
type DaemonCli struct {
	*daemon.Config
	configFile *string
	flags      *pflag.FlagSet

	api             *apiserver.Server
	d               *daemon.Daemon
	authzMiddleware *authorization.Middleware // authzMiddleware enables to dynamically reload the authorization plugins
}
```
### DaemonCli.start
1. SetDefaultOptions
2. loadDaemonCliConfig
3. setDefaultUmask
4. CreateDaemonRoot
5. create PID file
6. create server config
7. new apiServer
8. apiServer listen
9. create daemon
10. init swarm
11. initMidware
12. initRoute

### daemon
daemon 实现了 api/server/route/xxx/backend.go 中的所有方法
在 initRouter 时将 daemon 实例注入

### initRouter
```go
routers := []router.Router{
	// we need to add the checkpoint router before the container router or the DELETE gets masked
	checkpointrouter.NewRouter(d, decoder),
	container.NewRouter(d, decoder),
	image.NewRouter(d, decoder),
	systemrouter.NewRouter(d, c),
	volume.NewRouter(d),
	build.NewRouter(dockerfile.NewBuildManager(d)),
	swarmrouter.NewRouter(c),
	pluginrouter.NewRouter(d.PluginManager()),
}
```
