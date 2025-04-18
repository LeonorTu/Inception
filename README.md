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
For evaluation
```sh
scp -P 4241 -r /home/jtu/eval/evalname jtu@localhost:~/Desktop/Evaluation/evalname
```

### Docker Cleanup
Clean up Docker by stopping, removing, and deleting all containers, images, volumes and networks:

```sh
docker stop $(docker ps -qa); docker rm $(docker ps -qa);
docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
```

### View the Whole Inception Installation and Configuration Process
Run the following command to build and start all containers while displaying messages:
```sh
cd srcs
docker-compose up --build
```

### See Running Containers
To list all running containers:
```sh
docker ps
```

### See Logs for a Specific Container
To view logs for a specific container:
```sh
docker logs <container-name>
```

Alternatively, you can use:
```sh
cd ./srcs | docker-compose logs <container-name>
```

### Search for Hardcoded Credential
Search for sensitive keywords like "password", "key", "secret", etc.
```sh
grep -r "password" .
grep -r "key" .
grep -r "secret" .
```

### Check SSL/TLS Certificate
Use the following command to check the SSL/TLS certificate of your server:
```sh
openssl s_client -connect jtu.42.fr:443
```

### Inspect Docker Volumes
Inspect the details of a specific Docker volume:
```sh
docker volume inspect mariadb
docker volume inspect wordpress
```

### Access the service via http (port 80)
```sh
curl -I http://jtu.42.fr
```


### Access the Database
To access the MariaDB database inside the container:
```sh
docker exec -it mariadb sh
mysql -u root -p
```

Once inside the MySQL shell, you can run the following commands:

- Show all databases:
  ```sql
  SHOW DATABASES;
  ```

- Use the WordPress database:
  ```sql
  USE wordpress_db;
  ```

- Show all tables in the WordPress database:
  ```sql
  SHOW TABLES;
  ```

- View the contents of the `wp_users` table:
  ```sql
  SELECT * FROM wp_users;
  ```
