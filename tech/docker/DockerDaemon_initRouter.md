### initRouter

docker/cmd/dockerd/docker.go  

func initRouter (s *apiserver.Server, d *daemon.Daemon, c *cluster.Cluster) 

1. 创建decoder实例，用于解析配置文件

   ```golang
   decoder := runconfig.ContainerDecoder{}
   ```

2. 实例化router，backend为daemon实例

   ```golang
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

3. 注册router, createMux() 注册所有的请求路径与handler

   ```golang
   s.routers = append(s.routers, routers...)
   m := s.createMux()
   if enableProfiler {
   	profilerSetup(m)
   }
   s.routerSwapper = &routerSwapper{
   	router: m,
   }
   ```