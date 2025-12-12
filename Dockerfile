FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install Docker inside the Codespace container
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"

RUN apt-get update && apt-get install -y docker-ce-cli docker-compose-plugin

# Python build tools (for sanity)
RUN apt-get install -y python3 python3-pip python3-setuptools python3-wheel

CMD [ "sleep", "infinity" ]
