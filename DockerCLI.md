###DockerCli
```go
// DockerCli represents the docker command line client.
// Instances of the client can be returned from NewDockerCli.
type DockerCli struct {
	configFile      *configfile.ConfigFile
	in              *InStream
	out             *OutStream
	err             io.Writer
	keyFile         string
	client          client.APIClient
	hasExperimental bool
	defaultVersion  string
}
```

