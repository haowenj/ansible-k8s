使用方法
# 初始化环境
将shell目录中的init.sh复制到每个机器的/usr/local/bin目录下
```shell
ansible k8s  -m copy -a  "src=/usr/local/bin/init.sh dest=/usr/local/bin/init.sh"
```
然后执行init任务
```shell
ansible-playbook k8s-init.yaml
```
# 安装k8s相关的软件包
将shell目录中的install-k8s-pkg.sh复制到每个机器的/usr/local/bin目录下
```shell
ansible k8s  -m copy -a  "src=/usr/local/bin/install-k8s-pkg.sh dest=/usr/local/bin/install-k8s-pkg.sh"
```
然后执行install pkg任务
```shell
ansible-playbook install-k8s-pkg.yaml
```
# 初始化master节点
将shell目录中的create-master-node.sh复制到master节点的/usr/local/bin目录下。
将从发目录中的kubeadm.yml复制到自己服务器的指定目录，修改一下容器运行时和apiserver的地址。
然后执行create master node 任务
```shell
ansible-playbook create-master-node.yaml
```
# 工作节点加入
master节点初始化需要一点时间，初始化完了以后执行 create worker node任务
```shell
ansible-playbook create-worker-node.yaml
```
这里要注意，生成的join命令里不带容器运行时参数，如果使用的是containerd，服务器上没有docker的话，可以正常运行，如果服务器上有docker，用cri-docker当做运行时的话，需要在命令后边指定 --cri-socket参数。
```shell
"{{ my_command }} --cri-socket=unix:///var/run....."
```