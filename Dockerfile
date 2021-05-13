FROM centos:centos7.6.1810

# 标准centos+jdk
ENV BASE_DIR="/opt/apps" \
    JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk" \
    JAVA="/usr/lib/jvm/java-1.8.0-openjdk/bin/java" \
    TIME_ZONE="Asia/Shanghai"
ENV PATH ${JAVA_HOME}/bin:$PATH
ENV LC_ALL=zh_CN.utf8
ENV LANG=zh_CN.utf8
ENV LANGUAGE=zh_CN.utf8
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

WORKDIR $BASE_DIR

RUN mkdir -p ${BASE_DIR}
RUN yum install -y wget
RUN wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum clean all

RUN set -x \
    && yum update -y \
    && yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel iputils nc  vim libcurl
RUN yum autoremove -y wget \
    && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone \
    && yum clean all
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone
RUN mkdir -p /opt/maven/
RUN mkdir -p /opt/maven/repository
ADD ./maven.tar /opt/
RUN chmod -R 755 /opt/apache-maven-3.6.3/bin/
RUN echo "export M2_HOME=/opt/apache-maven-3.6.3" >> /etc/profile
RUN echo "export PATH=$PATH:$JAVA_HOME/bin:/opt/apache-maven-3.6.3/bin" >> /etc/profile
RUN source /etc/profile
ENTRYPOINT ["java","-version"]
