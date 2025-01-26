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
