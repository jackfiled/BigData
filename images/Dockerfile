FROM archlinux:latest

# Install necessary dependencies
RUN echo 'Server = https://mirrors.cernet.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
RUN pacman -Sy --noconfirm openssh jdk8-openjdk which inetutils

# Setting JAVA_HOME env
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk

# Configuring SSH login
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyyLt1bsAlCcadB2krSCDr0JP8SrF7EsUM+Qiv3m+V10gIBoCBFEh9iwpVN1UMioK8qdl9lm+LK22RW+IU6RjW+zyPB7ui3LlG0bk5H4g9v7uXH/+/ANfiJI2/2+Q4gOQAsRR+7kOpGemeKnFGJMgxnndSCpgYI4Is9ydAFzcQcGgxVB2mTGT6siufJb77tWKxrVzGn60ktdRxfwqct+2Nt88GTGw7eGJfMQADX1fVt9490M3G3x2Kw9KweXr2m+qr1yCRAlt3WyNHoNOXVhrF41/YgwGe0sGJd+kXBAdM2nh2xa0ZZPUGFkAp4MIWBDbycleRCeLUpCHFB0bt2D82BhF9luCeTXtpLyDym1+PS+OLZ3NDcvztBaH8trsgH+RkUc2Bojo1J4W9NoiEWsHGlaziWgF6L3z1vgesDPboxd0ol6EhKVX+QjxA9XE79IT4GidHxDwqonJz/dHXwjilqqmI4TEHndVWhJN0GV47a63+YCK02VAZ2mOA3aw/7LE= ricardo@magicbook-14' >> /root/.ssh/authorized_keys
COPY id_big_data /root/.ssh/id_rsa
RUN echo 'Host *' >> /etc/ssh/ssh_config && echo '    StrictHostKeyChecking no' >> /etc/ssh/ssh_config

# Install Hadoop
ADD hadoop-3.3.6.tar.gz /opt/
RUN mv /opt/hadoop-3.3.6 /opt/hadoop && \
    chmod -R 777 /opt/hadoop

# Configure Hadoop
ENV HADOOP_HOME=/opt/hadoop
RUN echo "slave1" >> $HADOOP_HOME/etc/hadoop/workers
RUN echo "slave2" >> $HADOOP_HOME/etc/hadoop/workers
RUN echo "slave3" >> $HADOOP_HOME/etc/hadoop/workers
RUN mkdir $HADOOP_HOME/tmp
ENV HADOOP_TMP_DIR=$HADOOP_HOME/tmp
RUN mkdir $HADOOP_HOME/namenode
RUN mkdir $HADOOP_HOME/datanode
ENV HADOOP_CONFIG_HOME=$HADOOP_HOME/etc/hadoop
ENV PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
ENV HADOOP_CLASSPATH=$HADOOP_HOME/share/hadoop/tools/lib/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_CLASSPATH
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"
COPY hadoop_config/* $HADOOP_HOME/etc/hadoop/
RUN sed -i '1i export JAVA_HOME=/usr/lib/jvm/java-8-openjdk' $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# Install zookeeper
ADD apache-zookeeper-3.9.2-bin.tar.gz /opt/
RUN mv /opt/apache-zookeeper-3.9.2-bin /opt/zookeeper && \
    chmod -R 777 /opt/zookeeper

# Configure zookeeper
ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV PATH=$ZOOKEEPER_HOME/bin:$PATH
RUN mkdir $ZOOKEEPER_HOME/tmp
COPY zookeeper_config/* $ZOOKEEPER_HOME/conf/

# Install hbase
ADD hbase-2.5.8-bin.tar.gz /opt/
RUN mv /opt/hbase-2.5.8 /opt/hbase && \
    chmod -R 777 /opt/hbase

# Configure hbase
ENV HBASE_HOME=/opt/hbase
ENV PATH=$HBASE_HOME/bin:$HBASE_HOME/sbin:$PATH
COPY hbase_config/* $HBASE_HOME/conf/
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk" >> $HBASE_HOME/conf/hbase-env.sh
RUN echo "export HBASE_MANAGES_ZK=false" >> $HBASE_HOME/conf/hbase-env.sh
RUN echo "export HBASE_LIBRARY_PATH=/opt/hadoop/lib/native" >> $HBASE_HOME/conf/hbase-env.sh
RUN echo 'export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP="true"' >> $HBASE_HOME/conf/hbase-env.sh

# Install spark
ADD spark-3.5.1-bin-hadoop3-scala2.13.tgz /opt/
RUN mv /opt/spark-3.5.1-bin-hadoop3-scala2.13 /opt/spark && \
    chmod -R 777 /opt/spark

# Configure spark
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV YARN_CONF_DIR=/opt/hadoop/etc/hadoop
RUN mv /opt/spark/conf/spark-env.sh.template /opt/spark/conf/spark-env.sh && \
    echo 'export SPARK_DIST_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath)' >> /opt/spark/conf/spark-env.sh && \
    touch /opt/spark/conf/workers && \
    echo "master" >> /opt/spark/conf/workers && \
    echo "slave1" >> /opt/spark/conf/workers && \
    echo "slave2" >> /opt/spark/conf/workers && \
    echo "slave3" >> /opt/spark/conf/workers

# Add Mysql JDBC Connector
COPY mysql-connector-j-8.4.0.jar /opt/spark/jars/

# Install flink
ADD flink-1.13.6-bin-scala_2.11.tgz /opt/
RUN mv /opt/flink-1.13.6 /opt/flink && \
    chmod -R 777 /opt/flink

# Add hadoop library
ADD commons-cli-1.4.jar /opt/flink/lib/
ADD flink-shaded-hadoop-3-uber-3.1.1.7.2.1.0-327-9.0.jar /opt/flink/lib/

# Configure flink
ENV FLINK_HOME=/opt/flink
ENV PATH=$FLINK_HOME/bin:$PATH
COPY flink_conf/* $FLINK_HOME/conf/

# Install kafka
ADD kafka_2.12-1.0.2.tgz /opt/
RUN mv /opt/kafka_2.12-1.0.2 /opt/kafka/ && \
    chmod -R 777 /opt/kafka

# Configure kafka
ENV KAFKA_HOME=/opt/kafka
ENV PATH=$KAFKA_HOME/bin:$PATH


COPY run.sh /run.sh
CMD [ "/run.sh" ]