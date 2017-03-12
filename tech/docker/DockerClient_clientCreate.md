### DockerClient 的 client对象创建

在docker/cmd/docker/docker.go中

```go
opts.Common.SetDefaultOptions(flags)
dockerPreRun(opts)
dockerCli.Initialize(opts)
```

主要是Initialize()函数，具体如下

docker/cli/command/cli.go

```go
func (cli *DockerCli) Initialize(opts *cliflags.ClientOptions) error {
	......
	cli.client, err = NewAPIClientFromFlags(opts.Common, cli.configFile)
	if err != nil {
		return err
	}
	......
}
```
### DockerClient 的初始化

DockerClient表示了docker客户端与docker daemon之间建立连接的实例，docker客户端调用docker daemon的API

初始化顺序：

1. docker/cmd/docker/docker.go

```go
func main() {
	...
	dockerCli := command.NewDockerCli(stdin, stdout, stderr)
	...
```

1. docker/cmd/docker/docker.go

```go
func newDockerCommand(dockerCli *command.DockerCli) *cobra.Command {
    ...
    cmd := &cobra.Command{
        PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		    ...
            // opts赋值顶级flag，不是命令级别的flag
			opts.Common.SetDefaultOptions(flags)
            // 设置日志级别，配置文件path，debug模式
			dockerPreRun(opts)
            // 初始化DockerClient
			if err := dockerCli.Initialize(opts); err != nil {
				return err
			}
			...
		},
     ...
```

1. docker/cli/command/cli.go

```go
func (cli *DockerCli) Initialize(opts *cliflags.ClientOptions) error {
    // 加载配置文件
	cli.configFile = LoadDefaultConfigFile(cli.err)
	var err error
  	// 新建APIClient
	cli.client, err = NewAPIClientFromFlags(opts.Common, cli.configFile)
	if err != nil {
		return err
	}
	cli.defaultVersion = cli.client.ClientVersion()

	if opts.Common.TrustKey == "" {
		cli.keyFile = filepath.Join(cliconfig.Dir(), cliflags.DefaultTrustKeyFile)
	} else {
		cli.keyFile = opts.Common.TrustKey
	}
	
  	// ping API 服务器
	if ping, err := cli.client.Ping(context.Background()); err == nil {
		cli.hasExperimental = ping.Experimental

		// since the new header was added in 1.25, assume server is 1.24 if header is not present.
		if ping.APIVersion == "" {
			ping.APIVersion = "1.24"
		}

		// if server version is lower than the current cli, downgrade
		if versions.LessThan(ping.APIVersion, cli.client.ClientVersion()) {
			cli.client.UpdateClientVersion(ping.APIVersion)
		}
	}
	return nil
}
```

1. docker/cli/command/cli.go

```go
func NewAPIClientFromFlags(opts *cliflags.CommonOptions, configFile *configfile.ConfigFile) (client.APIClient, error) {
    // 返回host strign
	host, err := getServerHost(opts.Hosts, opts.TLSOptions)
	if err != nil {
		return &client.Client{}, err
	}
	
	customHeaders := configFile.HTTPHeaders
	if customHeaders == nil {
		customHeaders = map[string]string{}
	}
	customHeaders["User-Agent"] = UserAgent()

	verStr := api.DefaultVersion
	if tmpStr := os.Getenv("DOCKER_API_VERSION"); tmpStr != "" {
		verStr = tmpStr
	}
	
    // 配置HTTP，TLS
	httpClient, err := newHTTPClient(host, opts.TLSOptions)
	if err != nil {
		return &client.Client{}, err
	}

	return client.NewClient(host, verStr, httpClient, customHeaders)
}
```