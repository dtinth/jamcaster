FROM node:14-buster

RUN apt-get update -y

# Install Jamulus
COPY vendor/jamulus_headless_3.8.0_ubuntu_amd64+dtinth-26dad5d.deb /tmp/jamulus_headless_3.8.0_ubuntu_amd64+dtinth-26dad5d.deb
RUN apt-get install -y /tmp/jamulus_headless_3.8.0_ubuntu_amd64+dtinth-26dad5d.deb

# Install tools
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y jackd2 ffmpeg supervisor

# Copy files
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY ffmpeg.sh .

CMD supervisord