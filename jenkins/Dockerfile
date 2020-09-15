FROM jenkins/jenkins:lts

LABEL maintainer="Luigi Di Fraia"

USER ROOT

# From my own Gist @ https://gist.github.com/luigidifraia/4286871762d161f4daa89b83d23a7727

# Docker CE installation
RUN apt-get update && apt-get install -y \
	  apt-transport-https \
	  ca-certificates \
	  curl \
	  gnupg-agent \
	  software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

RUN apt-get update && apt-get install -y docker-ce

RUN usermod -a -G docker jenkins

COPY docker-daemon.json /etc/docker/daemon.json

RUN kill -SIGHUP $(pidof dockerd)

# From https://kubernetes.io/docs/tasks/tools/install-kubectl/

# Kubectl installation
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    gnupg2

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN add-apt-repository \
    "deb [arch=amd64] https://apt.kubernetes.io \
    $(lsb_release -cs) \
    stable"

RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list

RUN sudo apt-get update && sudo apt-get install -y kubectl

# Install default plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER jenkins
