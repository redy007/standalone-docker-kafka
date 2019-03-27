FROM centos:7
MAINTAINER MSI

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_MAJOR_VERSION=8


RUN yum clean all && \
      yum install -y yum install epel-release && \
      yum update -y && \
      yum clean all
      
RUN yum install -y dos2unix curl wget tar

# /dev/urandom is used as random source, which is prefectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN yum install -y \
       java-1.8.0-openjdk-1.8.0.191.b12-1.el7_6 \ 
       java-1.8.0-openjdk-devel-1.8.0.191.b12-1.el7_6 \ 
    && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/java/jre/lib/security/java.security \
    && yum clean all

ENV JAVA_HOME /etc/alternatives/jre


RUN useradd kafka -m
RUN usermod -aG wheel kafka
USER kafka
RUN mkdir ~/Downloads
RUN curl "https://www-us.apache.org/dist/kafka/2.1.1/kafka_2.12-2.1.1.tgz" -o ~/Downloads/kafka.tgz
RUN mkdir ~/kafka && cd ~/kafka && tar -xvzf ~/Downloads/kafka.tgz --strip 1 \
&& mkdir -p data/zookeeper && mkdir -p data/kafka

RUN echo "PATH=$PATH:/home/kafka/kafka/bin/" >> ~/.bash_profile && echo "export $PATH" >> ~/.bash_profile

# ENTRYPOINT ["/bin/bash"] 