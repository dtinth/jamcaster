FROM node:14-bullseye

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y

# Install Jamulus
COPY vendor/jamulus_3.8.0_ubuntu_amd64+dtinth-aadabea.deb /tmp/jamulus_3.8.0_ubuntu_amd64+dtinth-aadabea.deb
RUN apt-get install -y /tmp/jamulus_3.8.0_ubuntu_amd64+dtinth-aadabea.deb

# Install tools
RUN apt-get install -y jackd1 ffmpeg supervisor xvfb chromium x11vnc tmux openbox fonts-noto-color-emoji fonts-noto fonts-noto-cjk

# Copy files
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY src/ src/

CMD ./src/entrypoint.sh