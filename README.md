## Docker Concepts

### Docker Basics
- **Docker**: Platform that packages applications with dependencies into isolated containers, ensuring consistent execution across environments
- **Container**: Lightweight, standalone executable package that includes everything needed to run an application (like VM)
- **Image**: Read-only template used to create containers, containing application code, runtime, libraries, and dependencies (like VM snapshot)
- **Dockerfile**: Script of instructions to build a Docker image (like auto install VM)

### Docker Compose
Docker Compose is a tool that defines and manages multi-container Docker applications using YAML files.

**Without Docker Compose:**
- You would run multiple `docker build` and `docker run` commands manually
- Need to manage networks and volumes separately with explicit commands
- Example: `docker run -d --name mariadb -p 3306:3306 -v mariadb:/var/lib/mysql --network docker-network mariadb:10.11.11`

**With Docker Compose:**
- Single configuration file defines everything
- One command (`docker compose up`) handles all container creation
- Automatic dependency resolution between services (like WordPress depending on MariaDB)
- Easier service updates and management

### Docker vs Virtual Machines
Docker provides significant advantages over VMs:

| Docker | Virtual Machines |
|--------|------------------|
| Shares host OS kernel | Requires full OS per VM |
| Starts in seconds | Boots in minutes |
| MB in size | GB in size |
| Lower resource overhead | Higher resource overhead |
| Consistent environments | Potential configuration drift |

## VM Management

### SSH Connection
```sh
ssh localhost -p 4241
```

### File Transfers
```sh
# Local to VM
scp -P 4241 -r /local/path user@localhost:~/remote/path

# VM to Local
scp -P 4241 -r user@localhost:~/remote/path /local/path
```

### Docker Cleanup
Clean up Docker by stopping, removing, and deleting all containers, images, volumes and networks:

```sh
docker stop $(docker ps -qa); docker rm $(docker ps -qa);
docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
```
