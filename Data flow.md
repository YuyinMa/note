# Data flow

### heapster://metrics/sinks/influxdb/influxdb.go

ExportData

* sink.sendData(dataPoints)
  * sink.client.Write(bp)

### heapster://metrics/manager/manager.go

housekeep

* data := rm.source.ScrapeMetrics(start, end)


* rm.sink.ExportData(data)

### metrics/sources/summary/summary.go

ScrapeMetrics

* return this.kubeletClient.GetSummary(this.node.Host)

### metrics/sources/kubelet/kubelet_client.go

GetSummary

* err = self.postRequestAndGetValue(client, req, summary)



### core/metrics.go

```go
// Provided by Kubelet/cadvisor.
var StandardMetrics = []Metric{
  MetricUptime,
  MetricCpuUsage,
  MetricMemoryUsage,
  MetricMemoryWorkingSet,
  MetricMemoryPageFaults,
  MetricMemoryMajorPageFaults,
  MetricNetworkRx,
  MetricNetworkRxErrors,
  MetricNetworkTx,
  MetricNetworkTxErrors
}
// Metrics computed based on cluster state using Kubernetes API.
var AdditionalMetrics = []Metric{ ...
// Computed based on corresponding StandardMetrics.
var RateMetrics = []Metric{ ...
var RateMetricsMapping = map[string]Metric{ ...
var LabeledMetrics = []Metric{ ...
var NodeAutoscalingMetrics = []Metric{ ...

```


### 疑惑

1. k8s会在每个node(minor)节点上部署一个Kubelet，默认暴露10250端口，Kubelet主要负责容器的生命周期管理和状态维护，以及监控数据采集。实际上，Kubelet也是通过cAdvisor来采集容器性能数据的，所以需要在Kubelet的启动参数中增加--cadvisor_port参数，它表示本地的cAdvisor服务端口号
2. heapster配合k8s运行时，需要指定kubernetes_master的地址，heapster通过k8s得到所有node节点地址，然后通过访问对应的node ip和端口号(10250)来调用目标节点Kubelet的HTTP接口，再由Kubelet调用cAdvisor服务获取该节点上所有容器的性能数据，并依次返回到heapster进行数据聚合。
3. 在较新的Kubernetes版本里，cadvior功能已经被集成到了kubelet组件中。在Node节点上可以直接访问cadvisor 的界面

### heapster 调用 kubelet API

https://10.10.103.116:10250/stats/container/

https://10.10.103.116:10250/stats/summary/



### kubernetes/pkg/kubelet/server/stats/summary.go

Get()

* infos, err := sp.provider.GetContainerInfoV2("/", options)
* node, err := sp.provider.GetNode()
* nodeConfig := sp.provider.GetNodeConfig()
* imageFsInfo, err := sp.provider.ImagesFsInfo()
* imageStats, err := sp.runtime.ImageStats()
* sb := &summaryBuilder{sp.fsResourceAnalyzer, node, nodeConfig, rootFsInfo, imageFsInfo, *imageStats, infos}
* return sb.build()

```
summaryProviderImpl.StatsProvider
```

### kubernetes/pkg/kubelet/cadvisor/cadvisor_linux.go

ImagesFsInfo()

* return cc.getFsInfo(label)         (cc: cadvisorClient => manager.Manager)
* manager.Manager 是 cAdvisor 的Manager



### TODO

1. cadvisorClient 在哪里注入
2. 是否要改 kubelet 代码



### 参考

http://fengchj.com/?tag=heapster (cAdvisor, heapster, kubelet运作机制)