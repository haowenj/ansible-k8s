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
然后执行create master node 任务
```shell
ansible-playbook create-master-node.yaml
```
# 工作节点加入
master节点初始化需要一点时间，初始化完了以后执行 create worker node任务
```shell
ansible-playbook create-worker-node.yaml
```