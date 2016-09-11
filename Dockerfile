FROM clouder/clouder-base
MAINTAINER Yannick Buron yburon@goclouder.net

USER root

# update apt-get and install needed tools for the gitlab installation
RUN apt-get update -y
RUN apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev libpq-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev logrotate python-docutils pkg-config cmake nodejs ruby ruby-dev golang git supervisor postgresql-client nginx

ADD sources/default /etc/default/gitlab
RUN gem install bundler --no-ri --no-rdoc

# create a user for gitlab
RUN useradd -d /home/git  -s /bin/bash git
RUN mkdir /home/git
RUN chown git:git /home/git
RUN adduser git sudo

RUN echo "[supervisord]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:gitlab]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'command=/opt/gitlab/files/lib/support/init.d/gitlab restart' >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:nginx]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'command=/etc/init.d/nginx restart' >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:sshd]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'command=/etc/init.d/ssh start' >> /etc/supervisor/conf.d/supervisord.conf

CMD /usr/bin/supervisord
