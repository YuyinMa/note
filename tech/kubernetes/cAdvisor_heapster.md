# relationship

1. k8s会在每个minion节点上部署一个Kubelet暴露10250端口，Kubelet主要负责容器的生命周期管理和状态维护，以及监控数据采集
2. Kubelet通过cAdvisor来采集容器性能数据，在Kubelet的启动参数中增加--cadvisor_port参数
3. Google开源组件 heapster 对Docker集群的监控
4. 当heapster配合k8s运行时，指定kubernetes_master的地址，heapster通过k8s得到所有node节点地址，然后通过访问对应的node ip和端口号(10250)来调用目标节点Kubelet的HTTP接口，再由Kubelet调用cAdvisor服务获取该节点上所有容器的性能数据，并依次返回到heapster进行数据聚合。

#### heapster聚合的metric可分为以下几类
  
  * uptime
  * cpu/usage
  * memory/usage
  * memory/page_faults
  * memory/working_set
  * network/rx
  * network/rx_errors
  * network/tx
  * network/tx_errors
  * filesystem/usage

# data storage
1. 默认cAdvisor是将数据缓存在内存中，因此数据展示能力有限，当然它也提供不同的持久化存储后端：云端的Google BigQuery或者本地端的InfluxDB，通过-storage_driver启动参数指定。

2. heaspter也支持多种存储后端，比如默认的memory，表示存内存，另外还有influxdb、bigquery、gcm，可由-sink启动参数指定。如果持久化到InfluxDB，那么根据metric的分类，

#### InfluxDB会生成以下series:

  * cpu/usage_ns_cumulative
  * filesystem/usage
  * memory/page_faults_gauge
  * memory/usage_bytes_gauge
  * memory/working_set_bytes_gauge
  * network/rx_bytes_cumulative
  * network/rx_errors_cumulative
  * network/tx_bytes_cumulative
  * network/tx_errors_cumulative
  * uptime_ms_cumulative

# deploy
#### get web service outside the k8s cluster
1. NodePort<br>
    you need to change grafana-service.yaml  to get monitoring-grafana service through Web Browser like http://10.10.103.116:30015/

        type: NodePort
        ports:
        - port: 80
          targetPort: 3000
          nodePort: 30015

2. LoadBalancer(TUDO)<br>
  ...

#### install cAdvisor<br>
    sudo docker run \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:rw \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --publish=8080:8080 \
    --detach=true \
    --name=cadvisor \
    google/cadvisor:latest

#### install heapster
1. deploy heapster podes

       kubectl create -f deploy/kube-config/influxdb/

2. fix grafana UIdoesn't show bug<br>
    remove GF_SERVER_ROOT_URL env in influxdb-grafana-controller.yaml
       # - name: GF_SERVER_ROOT_URL
       #  value: /api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/
3. grafana bug<br>
  now you can get grafana UI through web Browser, but you can't get any metric about your minion node<br>
  use Chronograf?

# refference
<http://ju.outofmemory.cn/entry/177936>
<https://github.com/kubernetes/heapster/issues/1316>
<https://github.com/kubernetes/heapster/blob/master/docs/influxdb.md>
<https://github.com/google/cadvisor>
