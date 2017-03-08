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
9. [create daemon instance](https://github.com/pengqinglan/note/blob/master/docker/DockerDaemon_daemonInstance.md)
10. init swarm
11. initMidware
12. [initRoute](https://github.com/pengqinglan/note/blob/master/docker/DockerDaemon_initRouter.md)

### code

```
func (cli *DaemonCli) start(opts daemonOptions) (err error) {
	stopc := make(chan bool)
	defer close(stopc)

	// warn from uuid package when running the daemon
	uuid.Loggerf = logrus.Warnf

	// step 1
	// 检测 TLS 设置情况，并对 TLS cert 和 key 进行验证
	opts.common.SetDefaultOptions(opts.flags)

	// step 2
	// 根据启动 flag 参数实例化 Config
	if cli.Config, err = loadDaemonCliConfig(opts); err != nil {
		return err
	}
	cli.configFile = &opts.configFile
	cli.flags = opts.flags

	if opts.common.TrustKey == "" {
		opts.common.TrustKey = filepath.Join(
			getDaemonConfDir(cli.Config.Root),
			cliflags.DefaultTrustKeyFile)
	}

	if cli.Config.Debug {
		debug.Enable()
	}

	if cli.Config.Experimental {
		logrus.Warn("Running experimental build")
	}

	logrus.SetFormatter(&logrus.TextFormatter{
		TimestampFormat: jsonlog.RFC3339NanoFixed,
		DisableColors:   cli.Config.RawLogs,
	})

	// step 3
	// 默认权限 755
	if err := setDefaultUmask(); err != nil {
		return fmt.Errorf("Failed to set umask: %v", err)
	}

	if len(cli.LogConfig.Config) > 0 {
		if err := logger.ValidateLogOpts(cli.LogConfig.Type, cli.LogConfig.Config); err != nil {
			return fmt.Errorf("Failed to set log opts: %v", err)
		}
	}

	// step 4
	// 在创建其他文件之前创建 daemon root 文件夹
	// Create the daemon root before we create ANY other files (PID, or migrate keys)
	// to ensure the appropriate ACL is set (particularly relevant on Windows)
	if err := daemon.CreateDaemonRoot(cli.Config); err != nil {
		return err
	}

	// step 5
	// 创建 pid file
	if cli.Pidfile != "" {
		pf, err := pidfile.New(cli.Pidfile)
		if err != nil {
			return fmt.Errorf("Error starting daemon: %v", err)
		}
		defer func() {
			if err := pf.Remove(); err != nil {
				logrus.Error(err)
			}
		}()
	}

	// step 6
	// 创建 apiserver config
	serverConfig := &apiserver.Config{
		Logging:     true,
		SocketGroup: cli.Config.SocketGroup,
		Version:     dockerversion.Version,
		EnableCors:  cli.Config.EnableCors,
		CorsHeaders: cli.Config.CorsHeaders,
	}

	if cli.Config.TLS {
		tlsOptions := tlsconfig.Options{
			CAFile:   cli.Config.CommonTLSOptions.CAFile,
			CertFile: cli.Config.CommonTLSOptions.CertFile,
			KeyFile:  cli.Config.CommonTLSOptions.KeyFile,
		}

		if cli.Config.TLSVerify {
			// server requires and verifies client's certificate
			tlsOptions.ClientAuth = tls.RequireAndVerifyClientCert
		}
		tlsConfig, err := tlsconfig.Server(tlsOptions)
		if err != nil {
			return err
		}
		serverConfig.TLSConfig = tlsConfig
	}

	if len(cli.Config.Hosts) == 0 {
		cli.Config.Hosts = make([]string, 1)
	}

	// step 7
	// 实例化 apiserver 结构体
	api := apiserver.New(serverConfig)
	cli.api = api

	// step 8
	// 开启 apiserver 监听
	for i := 0; i < len(cli.Config.Hosts); i++ {
		var err error
		if cli.Config.Hosts[i], err = dopts.ParseHost(cli.Config.TLS, cli.Config.Hosts[i]); err != nil {
			return fmt.Errorf("error parsing -H %s : %v", cli.Config.Hosts[i], err)
		}

		protoAddr := cli.Config.Hosts[i]
		protoAddrParts := strings.SplitN(protoAddr, "://", 2)
		if len(protoAddrParts) != 2 {
			return fmt.Errorf("bad format %s, expected PROTO://ADDR", protoAddr)
		}

		proto := protoAddrParts[0]
		addr := protoAddrParts[1]

		// It's a bad idea to bind to TCP without tlsverify.
		if proto == "tcp" && (serverConfig.TLSConfig == nil || serverConfig.TLSConfig.ClientAuth != tls.RequireAndVerifyClientCert) {
			logrus.Warn("[!] DON'T BIND ON ANY IP ADDRESS WITHOUT setting --tlsverify IF YOU DON'T KNOW WHAT YOU'RE DOING [!]")
		}
		ls, err := listeners.Init(proto, addr, serverConfig.SocketGroup, serverConfig.TLSConfig)
		if err != nil {
			return err
		}
		ls = wrapListeners(proto, ls)
		// If we're binding to a TCP port, make sure that a container doesn't try to use it.
		if proto == "tcp" {
			if err := allocateDaemonPort(addr); err != nil {
				return err
			}
		}
		logrus.Debugf("Listener created for HTTP on %s (%s)", proto, addr)
		api.Accept(addr, ls...)
	}

	if err := migrateKey(cli.Config); err != nil {
		return err
	}

	// FIXME: why is this down here instead of with the other TrustKey logic above?
	cli.TrustKeyPath = opts.common.TrustKey

	registryService := registry.NewService(cli.Config.ServiceOptions)
	containerdRemote, err := libcontainerd.New(cli.getLibcontainerdRoot(), cli.getPlatformRemoteOptions()...)
	if err != nil {
		return err
	}
	signal.Trap(func() {
		cli.stop()
		<-stopc // wait for daemonCli.start() to return
	})

	// step 9
	// 生成 daemon 对象
	d, err := daemon.NewDaemon(cli.Config, registryService, containerdRemote)
	if err != nil {
		return fmt.Errorf("Error starting daemon: %v", err)
	}

	if cli.Config.MetricsAddress != "" {
		if !d.HasExperimental() {
			return fmt.Errorf("metrics-addr is only supported when experimental is enabled")
		}
		if err := startMetricsServer(cli.Config.MetricsAddress); err != nil {
			return err
		}
	}

	name, _ := os.Hostname()

	// step 10
	// 初始化集群
	c, err := cluster.New(cluster.Config{
		Root:                   cli.Config.Root,
		Name:                   name,
		Backend:                d,
		NetworkSubnetsProvider: d,
		DefaultAdvertiseAddr:   cli.Config.SwarmDefaultAdvertiseAddr,
		RuntimeRoot:            cli.getSwarmRunRoot(),
	})
	if err != nil {
		logrus.Fatalf("Error creating cluster component: %v", err)
	}

	// Restart all autostart containers which has a swarm endpoint
	// and is not yet running now that we have successfully
	// initialized the cluster.
	d.RestartSwarmContainers()

	logrus.Info("Daemon has completed initialization")

	logrus.WithFields(logrus.Fields{
		"version":     dockerversion.Version,
		"commit":      dockerversion.GitCommit,
		"graphdriver": d.GraphDriverName(),
	}).Info("Docker daemon")

	cli.d = d

	// step 11
	// 设置中间件
	// initMiddlewares needs cli.d to be populated. Dont change this init order.
	if err := cli.initMiddlewares(api, serverConfig); err != nil {
		logrus.Fatalf("Error creating middlewares: %v", err)
	}
	d.SetCluster(c)

	// step 12
	// 设置路由信息
	initRouter(api, d, c)

	// step 13
	// 捕捉退出 signal
	cli.setupConfigReloadTrap()

	// The serve API routine never exits unless an error occurs
	// We need to start it as a goroutine and wait on it so
	// daemon doesn't exit
	serveAPIWait := make(chan error)
	go api.Wait(serveAPIWait)

	// after the daemon is done setting up we can notify systemd api
	notifySystem()

	// Daemon is fully initialized and handling API traffic
	// Wait for serve API to complete
	errAPI := <-serveAPIWait
	c.Cleanup()
	shutdownDaemon(d)
	containerdRemote.Cleanup()
	if errAPI != nil {
		return fmt.Errorf("Shutting down due to ServeAPI error: %v", errAPI)
	}

	return nil
}
```

### daemon
daemon 实现了 api/server/route/xxx/backend.go 中的所有方法
在 initRouter 时将 daemon 实例注入

backend其实就是daemon对象

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
