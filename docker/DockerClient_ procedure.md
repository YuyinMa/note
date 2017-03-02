# DockerClient一次请求的运作流程

DockerClient与DockerDaemon之间的关系是一个典型的C/S架构，DockerDaemon启动了一系列api服务，DockerClient根据指令来请求服务并得到返回结果。

### DockerClient命令的注册

docker/cmd/docker/docker.go 中注册了所有命令，命令包括根命令、一级命令和一级命令的子命令

```go
// 加入所有一级命令
commands.AddCommands(cmd, dockerCli)
```

AddCommands函数定义在 docker/cli/command/commands/commands.go

```go
// AddCommands adds all the commands from cli/command to the root command
// 在此注册所有的一级命令
func AddCommands(cmd *cobra.Command, dockerCli *command.DockerCli) {
	cmd.AddCommand(
		......
		swarm.NewSwarmCommand(dockerCli),
		container.NewContainerCommand(dockerCli),
		image.NewImageCommand(dockerCli),
		container.NewRunCommand(dockerCli),
		network.NewNetworkCommand(dockerCli),
        ......
    )
}
```

以`image.NewImageCommand(dockerCli)`为例，这条语句注册了image这个一级命令下的所有子命令。

docker/cli/command/image/cmd.go

```go
func NewImageCommand(dockerCli *command.DockerCli) *cobra.Command {
	...
	cmd.AddCommand(
		NewBuildCommand(dockerCli),
		NewLoadCommand(dockerCli),
        // docker pull命令的注册，下面例子
		NewImportCommand(dockerCli),
		NewPushCommand(dockerCli),
        ...
	)
	return cmd
}
```

### DockerClient执行命令 

以`docker pull`命令的执行为例，我们看一下注册这个命令的函数

docker/cli/command/image/pull.go

```go
// NewImportCommand creates a new `docker import` command
func NewImportCommand(dockerCli *command.DockerCli) *cobra.Command {
	var opts importOptions

	cmd := &cobra.Command{
		Use:   "import [OPTIONS] file|URL|- [REPOSITORY[:TAG]]",
		Short: "Import the contents from a tarball to create a filesystem image",
		Args:  cli.RequiresMinArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			opts.source = args[0]
			if len(args) > 1 {
				opts.reference = args[1]
			}
			return runImport(dockerCli, opts)
		},
	}

	flags := cmd.Flags()
	opts.changes = dockeropts.NewListOpts(nil)
	flags.VarP(&opts.changes, "change", "c", "Apply Dockerfile instruction to the created image")
	flags.StringVarP(&opts.message, "message", "m", "", "Set commit message for imported image")
	return cmd
}
```

一旦输入的指令符合cobra命令的要求，就会执行预先设定好的函数runPull(dockerCli, opts)

[client](https://github.com/pengqinglan/note/blob/master/docker/DockerClient.md)对象是与docker daemon连接的句柄，封装一系列请求api的实现

```go
func runImport(dockerCli *command.DockerCli, opts importOptions) error {
	...
	clnt := dockerCli.Client()
	responseBody, err := clnt.ImageImport(context.Background(), source, opts.reference, options)
    ...
}
```

### DockerClient请求的发送

api接口的定义在 docker/client/interface.go

```go
// ImageAPIClient defines API client methods for the images
type ImageAPIClient interface {
	...
	ImageImport(ctx context.Context, source types.ImageImportSource, ref string, options types.ImageImportOptions) (io.ReadCloser, error)
  	...
}
```

并给出了实现 docker/client/image_import.go

重点在于请求DockerDaemon的api服务

```go
// ImageImport creates a new image based in the source options.
// It returns the JSON content in the response body.
func (cli *Client) ImageImport(ctx context.Context, source types.ImageImportSource, ref string, options types.ImageImportOptions) (io.ReadCloser, error) {
	...
	resp, err := cli.postRaw(ctx, "/images/create", query, source.Source, nil)
	...
}

```

### DockerDaemon服务的执行