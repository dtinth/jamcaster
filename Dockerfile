FROM node:14-buster

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y

# Install Jamulus
COPY vendor/jamulus_3.8.0_ubuntu_amd64+dtinth-aadabea.deb /tmp/jamulus_3.8.0_ubuntu_amd64+dtinth-aadabea.deb
RUN apt-get install -y /tmp/jamulus_3.8.0_ubuntu_amd64+dtinth-aadabea.deb

# Install tools
RUN apt-get install -y jackd1 ffmpeg supervisor xvfb chromium pulseaudio x11vnc tmux openbox

# Copy files
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY src/ src/

CMD ./src/entrypoint.sh