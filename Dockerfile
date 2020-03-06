FROM jupyter/pyspark-notebook

USER root
WORKDIR $HOME
RUN mkdir $HOME/bin

#install jdk
RUN apt-get update && apt-get install -y openjdk-8-jdk && apt-get install zip
#download maven
RUN wget https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz && \
  tar xvf apache-maven-3.6.0-bin.tar.gz -C $HOME/bin/ && rm apache-maven-3.6.0-bin.tar.gz

ENV PATH=$HOME/bin/apache-maven-3.6.0/bin:$PATH 
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN cd $HOME/bin && git clone https://github.com/awslabs/aws-glue-libs.git && \
  cd aws-glue-libs && git checkout glue-1.0

# added to ignore servlet dependency conflict
COPY pom.xml $HOME/bin/aws-glue-libs

# download glue binaries using maven
RUN chmod +x $HOME/bin/aws-glue-libs/bin/glue-setup.sh && bash $HOME/bin/aws-glue-libs/bin/glue-setup.sh

# remove incompatible file
RUN rm $HOME/bin/aws-glue-libs/jarsv1/netty-all-4.0.23.Final.jar && \
  cp $SPARK_HOME/jars/netty-all-4.1.42.Final.jar $HOME/bin/aws-glue-libs/jarsv1/

ENV SPARK_CONF_DIR=$HOME/bin/aws-glue-libs/conf
ENV PYTHONPATH=${SPARK_HOME}python/:${SPARK_HOME}python/lib/py4j-0.10.7-src.zip:$HOME/bin/aws-glue-libs/PyGlue.zip:${PYTHONPATH}