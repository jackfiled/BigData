# 大数据技术基础

北京邮电大学2021级大数据基础课程成果仓库。

~~又名docker技术入门与实践~~。

## 课程简介

该课程主要由四次作业实验和两次期末实验组成。前四次作业实验的流程都是类似的：配置一种程序的环境->使用Java编写一小段代码使用这个环境。两次期末实验由一次移动平台实验和一次综合实验组成。本课程的一大特点就是提供了相当详尽的实验指导手册和评分标准，这造成该课程与其说是学习大数据的技术，不如说是如何在Linux系统上配置复杂的应用程序。之前的程序要求是在华为云上购买四个云服务器用来部署大数据中的各种分布式服务，但是今年华为的代金卷发放不是非常及时，因此本次课程建议使用`docker`在自己的电脑上搭建环境进行实验，故而这门课程又升级为了`docker`技术入门与实践。

综上所述，本仓库中提供的资料将不会聚焦于课程中需要编写的代码（这些代码都在实验指导书中提供了），而是聚焦于如何搭建课程中需要的`docker`环境和相关的实验报告。

## 实验报告

具体而言，在`Reports`文件夹中提供了我在本次课程中撰写的所有实验报告：

- 实验二：单词计数程序的编写
- 实验三：`HBase`数据库的安装和使用
- 实验四：`Spark`的安装和使用
- 期末实验一：金融行业羊毛党识别案例实践报告
- 期末实验二：`flink`和`kafka`的安装和使用

## 实验基础镜像

> 使用该镜像需要有基础的`docker`知识。

在`images`文件夹中提供了实验中需要使用到的各种软件的配置文件和`Dockerfile`、`docker-compose.yaml`。使用这些文件可以构建出一个安装了所有需要程序的基础镜像。

`images`文件夹下的文件大致有：

- `flink_conf`：`flink`的配置文件
- `hadoop_config`，`hadoop`的配置文件
- `zookeeper_config`：`zookeeper`的配置文件
- `hbase_config`：`hbase`的配置文件
- `id_big_data`：容器内使用的`ssh`私钥
- `run.sh`：容器的启动脚本，需要处理创建`zookeeper`的唯一ID和设置`zookeeper`的配置等问题
- `Dockerfile`：容器镜像文件
- `docker-compose.yaml`：容器启动脚本

在构建镜像之前需要手动下载各种软件的压缩包：

```shell
wget https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
wget https://www.apache.org/dyn/closer.lua/zookeeper/zookeeper-3.9.2/apache-zookeeper-3.9.2-bin.tar.gz
wget https://www.apache.org/dyn/closer.lua/hbase/2.5.8/hbase-2.5.8-bin.tar.gz
wget https://www.apache.org/dyn/closer.lua/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3-scala2.13.tgz
wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar
wget https://archive.apache.org/dist/flink/flink-1.13.6/flink-1.13.6-bin-scala_2.11.tgz
wget https://repo1.maven.org/maven2/commons-cli/commons-cli/1.4/commons-cli-1.4.jar
wget https://repository.cloudera.com/artifactory/cloudera-repos/org/apache/flink/flink-shaded-hadoop-3-uber/3.1.1.7.2.1.0-327-9.0/flink-shaded-hadoop-3-uber-3.1.1.7.2.1.0-327-9.0.jar
wget https://archive.apache.org/dist/kafka/1.0.2/kafka_2.12-1.0.2.tgz
```

在准备好上述文件之后，使用下述指令构建镜像：

```shell
docker build . -t big-data:latest
```

再使用下述指令即可运行四个容器：

```shell
docker compose up -d
```

使用下列指令可以进入容器进行实验：

```shell
docker exec -it <container name> bash
```

需要注意的时，每次摧毁容器并重新创建容器之后，需要重新执行`hadoop`环境初始化的各项工作。

如果需要修改运行容器的主机名，可以直接在`docker-compose.yaml`文件中修改四个容器配置的`hostname`字段。

在本地上需要使用主机名访问容器中的服务时，可以使用在`docker-compose.yaml`文件中给各个容器分配的IPv4地址，也可以在`/etc/hosts`文件中添加解析：

```
172.126.1.111 rcj-2021211180-node1
172.126.1.112 rcj-2021211180-node2
172.126.1.113 rcj-2021211180-node3
172.126.1.114 rcj-2021211180-node4
```

## 支持

如果您遇到了问题，我们十分欢迎您提出， 您可以通过发起`issue`或者是发送电子邮件的方式联系我们。

