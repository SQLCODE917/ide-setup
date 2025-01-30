# docker recipes
Because you want to containerize your local development environment

## docker-compose
To orchestrate your DBs, message queues, web applications, whatever

### How to make all containers talk to each other

```docker-compose.yml
services:
  postgres:
    ...
    ports:
      - "5432:5432"
    networks:
      - app-network
  webapp:
    depends_on:
      - postgres
    ...
    networks:
      - app-network
```

then, at run-time you can connect from `webapp` to `postgres` via `postgres:5432`
and you can use that address in your startup script too!

### How to pass SSH keys to a container

```docker-compose.yml
services:
  webapp:
    ...
    secrets:
      - my-github-key
    volumes:
      - ssh-agent:/ssh-agent
      ...
secrets:
  my-github-key:
    file: /Users/myuser/.ssh/id_rsa
volumes:
  ssh-agent:
```

```Dockerfile
# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libpq-dev \
    git \
    openssh-client

# Setup SSH
RUN mkdir -p /root/.ssh && \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

...
COPY startup.sh /usr/local/bin/startup.sh
run chmod +x /usr/local/bin/startup.sh
entrypoint ["/usr/local/bin/startup.sh"]
```

```startup.sh
# Start SSH agent and add key
eval $(ssh-agent -s)
ssh-add /run/secrets/my-github-key
```

### How to keep code on your local machine, dependencies in the container

```docker-compose.yml
services:
  webapp:
    ...
    volumes:
      - type: bind
        source: /Users/myuser/code/myproject
        target: /home/app/webapp
```

### How to pass environment variables

at build time:
```docker-compose.yml
services:
  webapp:
    build:
      ...
      args:
        - NODE_VERSION=16.20.2
```

```Dockerfile
ARG NODE_VERSION
...
RUN nvm install ${NODE_VERSION}
```

### How to inspect container network traffic

I want to spin up the whole stack and use a feature, then see what network traffic is going on.
Onboarding and debugging when "the truth is in the code".

tcpdump as the solution:
for every service, add a tcpdump container that will get you those nice pcap's

```docker-compose.yml
services:
  webapp:
    ...
  tcpdump_webapp:
    image: nicolaka/netshoot
    depends_on:
      - webapp
    command: tcpdump -i eth0 -A -w /logs/webapp_traffic.pcap
    network_mode: "service:webapp"
    cap_add:
      - NET_RAW
      - NET_ADMIN
    volumes:
      - ./logs:/logs
```

[trayce](https://trayce.dev/) as a solution:
UI that shows web traffic.
I have found it to not include all the traffic, but it's a user-friendly starting point

[traefik](https://traefik.io/) as a possible solution
TO EVALUATE
