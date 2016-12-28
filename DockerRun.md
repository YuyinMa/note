### param
```go
// opts:  flags not stored in Config/HostConfig
// copts: flags stored in Config/HostConfig
runRun(dockerCli, cmd.Flags(), &opts, copts)
```
### function code
```go
func runRun(dockerCli *command.DockerCli, flags *pflag.FlagSet, opts *runOptions, copts *runconfigopts.ContainerOptions) error {
	stdout, stderr, stdin := dockerCli.Out(), dockerCli.Err(), dockerCli.In()
	client := dockerCli.Client()
	// TODO: pass this as an argument
	cmdPath := "run"

	var (
		flAttach                              *opttypes.ListOpts
		ErrConflictAttachDetach               = fmt.Errorf("Conflicting options: -a and -d")
		ErrConflictRestartPolicyAndAutoRemove = fmt.Errorf("Conflicting options: --restart and --rm")
	)
  
  	// 根据flag参数生成配置文件 
	config, hostConfig, networkingConfig, err := runconfigopts.Parse(flags, copts)

	// just in case the Parse does not exit
	if err != nil {
		reportError(stderr, cmdPath, err.Error(), true)
		return cli.StatusError{StatusCode: 125}
	}

	if hostConfig.AutoRemove && !hostConfig.RestartPolicy.IsNone() {
		return ErrConflictRestartPolicyAndAutoRemove
	}
	if hostConfig.OomKillDisable != nil && *hostConfig.OomKillDisable && hostConfig.Memory == 0 {
		fmt.Fprintf(stderr, "WARNING: Disabling the OOM killer on containers without setting a '-m/--memory' limit may be dangerous.\n")
	}

	if len(hostConfig.DNS) > 0 {
		// check the DNS settings passed via --dns against
		// localhost regexp to warn if they are trying to
		// set a DNS to a localhost address
		for _, dnsIP := range hostConfig.DNS {
			if dns.IsLocalhost(dnsIP) {
				fmt.Fprintf(stderr, "WARNING: Localhost DNS setting (--dns=%s) may fail in containers.\n", dnsIP)
				break
			}
		}
	}

	config.ArgsEscaped = false

	if !opts.detach {
		if err := dockerCli.In().CheckTty(config.AttachStdin, config.Tty); err != nil {
			return err
		}
	} else {
		if fl := flags.Lookup("attach"); fl != nil {
			flAttach = fl.Value.(*opttypes.ListOpts)
			if flAttach.Len() != 0 {
				return ErrConflictAttachDetach
			}
		}

		config.AttachStdin = false
		config.AttachStdout = false
		config.AttachStderr = false
		config.StdinOnce = false
	}

	// Disable sigProxy when in TTY mode
	if config.Tty {
		opts.sigProxy = false
	}

	// Telling the Windows daemon the initial size of the tty during start makes
	// a far better user experience rather than relying on subsequent resizes
	// to cause things to catch up.
	if runtime.GOOS == "windows" {
		hostConfig.ConsoleSize[0], hostConfig.ConsoleSize[1] = dockerCli.Out().GetTtySize()
	}

	ctx, cancelFun := context.WithCancel(context.Background())

	createResponse, err := createContainer(ctx, dockerCli, config, hostConfig, networkingConfig, hostConfig.ContainerIDFile, opts.name)
	if err != nil {
		reportError(stderr, cmdPath, err.Error(), true)
		return runStartContainerErr(err)
	}
	if opts.sigProxy {
		sigc := ForwardAllSignals(ctx, dockerCli, createResponse.ID)
		defer signal.StopCatch(sigc)
	}
	var (
		waitDisplayID chan struct{}
		errCh         chan error
	)
	if !config.AttachStdout && !config.AttachStderr {
		// Make this asynchronous to allow the client to write to stdin before having to read the ID
		waitDisplayID = make(chan struct{})
		go func() {
			defer close(waitDisplayID)
			fmt.Fprintf(stdout, "%s\n", createResponse.ID)
		}()
	}
	attach := config.AttachStdin || config.AttachStdout || config.AttachStderr
	if attach {
		var (
			out, cerr io.Writer
			in        io.ReadCloser
		)
		if config.AttachStdin {
			in = stdin
		}
		if config.AttachStdout {
			out = stdout
		}
		if config.AttachStderr {
			if config.Tty {
				cerr = stdout
			} else {
				cerr = stderr
			}
		}

		if opts.detachKeys != "" {
			dockerCli.ConfigFile().DetachKeys = opts.detachKeys
		}

		options := types.ContainerAttachOptions{
			Stream:     true,
			Stdin:      config.AttachStdin,
			Stdout:     config.AttachStdout,
			Stderr:     config.AttachStderr,
			DetachKeys: dockerCli.ConfigFile().DetachKeys,
		}

		resp, errAttach := client.ContainerAttach(ctx, createResponse.ID, options)
		if errAttach != nil && errAttach != httputil.ErrPersistEOF {
			// ContainerAttach returns an ErrPersistEOF (connection closed)
			// means server met an error and put it in Hijacked connection
			// keep the error and read detailed error message from hijacked connection later
			return errAttach
		}
		defer resp.Close()

		errCh = promise.Go(func() error {
			errHijack := holdHijackedConnection(ctx, dockerCli, config.Tty, in, out, cerr, resp)
			if errHijack == nil {
				return errAttach
			}
			return errHijack
		})
	}

	statusChan := waitExitOrRemoved(ctx, dockerCli, createResponse.ID, hostConfig.AutoRemove)

	//start the container
	if err := client.ContainerStart(ctx, createResponse.ID, types.ContainerStartOptions{}); err != nil {
		// If we have holdHijackedConnection, we should notify
		// holdHijackedConnection we are going to exit and wait
		// to avoid the terminal are not restored.
		if attach {
			cancelFun()
			<-errCh
		}

		reportError(stderr, cmdPath, err.Error(), false)
		if hostConfig.AutoRemove {
			// wait container to be removed
			<-statusChan
		}
		return runStartContainerErr(err)
	}

	if (config.AttachStdin || config.AttachStdout || config.AttachStderr) && config.Tty && dockerCli.Out().IsTerminal() {
		if err := MonitorTtySize(ctx, dockerCli, createResponse.ID, false); err != nil {
			fmt.Fprintf(stderr, "Error monitoring TTY size: %s\n", err)
		}
	}

	if errCh != nil {
		if err := <-errCh; err != nil {
			logrus.Debugf("Error hijack: %s", err)
			return err
		}
	}

	// Detached mode: wait for the id to be displayed and return.
	if !config.AttachStdout && !config.AttachStderr {
		// Detached mode
		<-waitDisplayID
		return nil
	}

	status := <-statusChan
	if status != 0 {
		return cli.StatusError{StatusCode: status}
	}
	return nil
}
```
