FROM library/ubuntu:latest
MAINTAINER user@gmail.com

#
# Ubuntu with Oracle JDK 8
#

# Install and setup project dependencies
ARG SBT_VERSION=1.3.13

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get -y update && \
  apt-get -y install software-properties-common && \
  add-apt-repository -y ppa:git-core/ppa && \
  apt-get -y update && \
  apt-get -y install curl wget unzip nano git && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y install oracle-java8-installer && \
  apt-get -y install oracle-java8-unlimited-jce-policy && \
  apt-get -y install oracle-java8-set-default && \

    # Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

RUN \
  sbt test && \
  sbt run

