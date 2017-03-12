# Heapster 基本概念

### 核心组件

1. **Heapster core**
   * 从 kubernetes 集群节点读 metrics
   * 处理数据并持久化
   * 通过 Model API 向其他 kubernetes 组件提供 metrics
2. **Eventer**
   * 从 kubernetes master 中读 events
   * 持久化

### 配置数据源

1. heapster 跑在 kubernetes 内部

   ```shell
   --source=kubernetes
   ```


2. heapster 跑在 kubernetes 外部

   ```shell
   --source=kubernetes:<KUBERNETES_MASTER>[?<KUBERNETES_OPTIONS>]
   ```

### 接入验证

1. Heapster 需要身份验证 token 来连接 api-server 

2. 默认使用 inClusterConfig 系统来配置安全连接

3. 不使用身份验证来连接 api-server（需要api-server不设置身份验证）

   ```shell
   --source=kubernetes:http://<address-of-kubernetes-master>:<http-port>?inClusterConfig=false
   ```

4. 还可以使用 heapster-only serviceaccount 来接入 api-server

### 持久化

1. influxdb

   ```shell
   # 单独运行
   --sink=influxdb:<INFLUXDB_URL>[?<INFLUXDB_OPTIONS>]
   # Run Heapster in a Kubernetes cluster with the default InfluxDB + Grafana setup
   --sink=influxdb:http://monitoring-influxdb:80/
   ```

2. Elasticsearch

   ```shell
   # 单节点
   --sink=elasticsearch:<ES_SERVER_URL>[?<OPTIONS>]
   # 多节点
   --sink=elasticsearch:?nodes=foo.com:9200&nodes=bar.com:9200
   ```



# Heapster 配置文件 

heapster 跑在 kubernetes 上的配置文件

1. heapster-deployment.yaml

   ```yaml
   kind:      Deployment
   namespace: kube-system
   image:     kubernetes/heapster:canary
   command:
           - /heapster
           - --source=kubernetes:https://kubernetes.default
           - --sink=influxdb:http://monitoring-influxdb:8086
   ```

2. influxdb-deployment.yaml

   ```yaml
   kind:      Deployment
   namespace: kube-system
   image:     kubernetes/heapster_influxdb:v0.6
   ```

3. heapster-service.yaml

   ```yaml
   kind: Service
   namespace: kube-system
   ports:
   - port: 80
     targetPort: 8082
   ```

4. influxdb-service.yaml

   ```yaml
   kind: Service
   namespace: kube-system
   ports:
   # - name: http
   #   port: 80
   #   targetPort: 8083
   - name: api
     port: 8086
     targetPort: 8086
   ```

# Metrics

Heapster exports the following metrics to its backends.

| Metric Name                   | Description                              |
| ----------------------------- | ---------------------------------------- |
| cpu/limit                     | CPU hard limit in millicores.            |
| cpu/node_capacity             | Cpu capacity of a node.                  |
| cpu/node_reservation          | Share of cpu that is reserved on the node. |
| cpu/node_utilization          | CPU utilization as a share of node capacity. |
| cpu/request                   | CPU request (the guaranteed amount of resources) in millicores. |
| cpu/usage                     | Cumulative CPU usage on all cores.       |
| cpu/usage_rate                | CPU usage on all cores in millicores.    |
| filesystem/usage              | Total number of bytes consumed on a filesystem. |
| filesystem/limit              | The total size of filesystem in bytes.   |
| filesystem/available          | The number of available bytes remaining in a the filesystem |
| memory/limit                  | Memory hard limit in bytes.              |
| memory/major_page_faults      | Number of major page faults.             |
| memory/major_page_faults_rate | Number of major page faults per second.  |
| memory/node_capacity          | Memory capacity of a node.               |
| memory/node_reservation       | Share of memory that is reserved on the node. |
| memory/node_utilization       | Memory utilization as a share of memory capacity. |
| memory/page_faults            | Number of page faults.                   |
| memory/page_faults_rate       | Number of page faults per second.        |
| memory/request                | Memory request (the guaranteed amount of resources) in bytes. |
| memory/usage                  | Total memory usage.                      |
| memory/working_set            | Total working set usage. Working set is the memory being used and not easily dropped by the kernel. |
| network/rx                    | Cumulative number of bytes received over the network. |
| network/rx_errors             | Cumulative number of errors while receiving over the network. |
| network/rx_errors_rate        | Number of errors while receiving over the network per second. |
| network/rx_rate               | Number of bytes received over the network per second. |
| network/tx                    | Cumulative number of bytes sent over the network |
| network/tx_errors             | Cumulative number of errors while sending over the network |
| network/tx_errors_rate        | Number of errors while sending over the network |
| network/tx_rate               | Number of bytes sent over the network per second. |
| uptime                        | Number of milliseconds since the container was started. |

All custom (aka application) metrics are prefixed with 'custom/'.

# 源码结构

Makefie

```shell
build: clean deps
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 godep go build -o heapster k8s.io/heapster/metrics
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 godep go build -o eventer k8s.io/heapster/events
```