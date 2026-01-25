# Developer Documentation

This guide explains how to set up, build, and modify the Inception infrastructure.

## Environment Setup

### Prerequisites

1. **Virtual Machine**
   - Debian-based OS (Debian 12 recommended)
   - Minimum 2GB RAM, 16GB disk space
   - User with sudo privileges

2. **Required Software**
   ```bash
   # Update package lists
   sudo apt update

   # Install Docker
   sudo apt install -y docker.io docker-compose

   # Add user to docker group (logout/login required)
   sudo usermod -aG docker $USER

   # Install Make
   sudo apt install -y make

   # Optional GUI - openbox, xinit, kitty, firefox-esr for browser testing
   sudo apt-get install git wget zsh vim make openbox xinit kitty firefox-esr filezilla -y
   ```

3. **Verify Installation**
   ```bash
   docker --version
   docker-compose --version
   make --version
   ```

### Initial Configuration

1. **Clone Repository**
   ```bash
   git clone https://github.com/rda-cunh/42_Inception.git (or link from vogsphere during evaluation)
   cd 42_Inception
   ```

2. **Configure Environment Variables**
   ```bash
   # Edit configuration file (unavailable on repository during evaluation for security reasons)
   nano srcs/.env
   ```

   **Required variables**:
   - `WP_URL` - Your domain (e.g., `yourusername.42.fr`)
   - `COMMON_NAME` - Same as WP_URL
   - Database credentials (DB_NAME, DB_USER, DB_PASSWORD, DB_PASS_ROOT)
   - WordPress admin credentials (WP_ADMIN_USER, WP_ADMIN_PASSWORD, WP_ADMIN_EMAIL)
   - WordPress user credentials (WP_USER, WP_PASSWORD, WP_EMAIL)

3. **Update Makefile**
   ```bash
   # Edit Makefile and change HOST_URL variable
   nano Makefile

   # Change this line to match your username:
   HOST_URL = yourusername.42.fr
   ```

4. **Create Data Directories**
   ```bash
   # Directories will be created automatically by Makefile
   # Manual creation (optional):
   mkdir -p ~/data/database ~/data/wordpress_files
   ```

## Building and Launching

### Using Makefile (Recommended)

```bash
# Build images and start containers (default target)
make
# Or explicitly:
make up

# Start existing containers without rebuilding
make start

# Stop containers without removing them
make stop

# Stop and remove containers (preserves volumes)
make down

# Restart the infrastructure (down + up)
make restart

# Clean up (stop containers and remove volumes)
make clean

# Full cleanup (remove images, volumes, data, and host entry)
make fclean

# Rebuild everything from scratch (fclean + all)
make re

# Display status of all Docker resources
make status

# Follow container logs in real-time
make logs
```

### Using Docker Compose Directly

```bash
# Navigate to source directory
cd srcs

# Build and start
docker-compose up --build -d

# Stop
docker-compose down

# View logs
docker-compose logs -f
```

## Container Management

### Basic Commands

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# View logs for specific container
docker logs nginx
docker logs wordpress
docker logs mariadb

# Follow logs in real-time
docker logs -f nginx

# Execute commands inside container
docker exec -it nginx /bin/bash
docker exec -it wordpress /bin/bash
docker exec -it mariadb /bin/bash

# Restart specific container
docker restart nginx
```

### Debugging Containers

```bash
# Check container health and status
docker inspect nginx

# View container resource usage
docker stats

# View detailed logs with timestamps
docker logs --timestamps nginx

# Check last 50 log lines
docker logs --tail 50 wordpress
```

### Rebuilding Specific Services

```bash
# Rebuild only NGINX
docker-compose -f srcs/docker-compose.yml build nginx
docker-compose -f srcs/docker-compose.yml up -d nginx

# Rebuild all services
docker-compose -f srcs/docker-compose.yml build --no-cache
```

## Volume Management

### Listing Volumes

```bash
# List all volumes
docker volume ls

# Inspect specific volume
docker volume inspect inception_database
docker volume inspect inception_wordpress_files
```

### Data Location

Data persists in bind-mounted directories:
- **Database**: `~/data/database/`
- **WordPress**: `~/data/wordpress_files/`

### Backup and Restore

```bash
# Backup (while containers are stopped)
make stop
tar -czf inception-backup.tar.gz ~/data/

# Restore
make stop
tar -xzf inception-backup.tar.gz -C ~/
make start
```

### Clearing Volumes

```bash
# Remove volumes (WARNING: deletes all data)
make clean

# Manual volume removal
docker volume rm inception_database inception_wordpress_files
rm -rf ~/data/database ~/data/wordpress_files
```

## Data Persistence

### Database Storage

- **Location**: `~/data/database/`
- **Contents**: MariaDB data files (`.frm`, `.ibd`, `ib_logfile`, etc.)
- **Managed by**: MariaDB container writes directly to host filesystem
- **Persistence**: Data survives container restarts and rebuilds

### WordPress Files

- **Location**: `~/data/wordpress_files/`
- **Contents**:
  - WordPress core files (`wp-admin/`, `wp-includes/`, `wp-content/`)
  - Uploaded media (`wp-content/uploads/`)
  - Themes and plugins (`wp-content/themes/`, `wp-content/plugins/`)
  - Configuration (`wp-config.php`)
- **Persistence**: All uploads and customizations persist across container lifecycles

### Volume Configuration

Volumes are defined in `srcs/docker-compose.yml`:

```yaml
volumes:
  database:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ~/data/database

  wordpress_files:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ~/data/wordpress_files
```

**Key points**:
- `type: none` with `o: bind` creates bind mounts
- Data is directly accessible from host for debugging/backup
- Host paths must exist before container start (created by Makefile)

## Project Structure

```
42_Inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/           # Configuration files
        │   └── tools/          # Setup and initialization scripts
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/           # WordPress and PHP-FPM configuration
        │   └── tools/          # WordPress installation scripts
        └── nginx/
            ├── Dockerfile
            └── conf/           # Server config and SSL setup
```

## Network Architecture

Services communicate through a Docker bridge network named `all`:

- **NGINX** (port 443) ← External access only
  - Forwards to **WordPress** (port 9000 - internal)
    - Connects to **MariaDB** (port 3306 - internal)

Only NGINX exposes ports to the host machine. Internal services are isolated.

## Development Workflow

1. **Make Changes**
   - Edit Dockerfiles, configuration files, or scripts
   - Update `.env` for credential changes

2. **Test Changes**
   ```bash
   # Rebuild affected service
   make restart

   # Or rebuild specific container
   docker-compose -f srcs/docker-compose.yml up -d --build nginx
   ```

3. **Debug Issues**
   ```bash
   # Check logs
   make logs

   # Enter container for inspection
   docker exec -it nginx /bin/bash
   ```

4. **Validate**
   - Test website functionality
   - Check WordPress admin panel
   - Verify database connections

## Common Development Tasks

### Changing Domain Name

1. Edit `srcs/.env`: Update `WP_URL` and `COMMON_NAME`
2. Edit `Makefile`: Update `HOST_URL`
3. Rebuild: `make re`

### Updating SSL Certificate

SSL certificates are self-signed and generated in NGINX Dockerfile. To regenerate:

```bash
# Rebuild NGINX container
docker-compose -f srcs/docker-compose.yml build --no-cache nginx
docker-compose -f srcs/docker-compose.yml up -d nginx
```

### Adding New Services

1. Create service directory in `srcs/requirements/`
2. Add Dockerfile and configuration files
3. Update `srcs/docker-compose.yml` with new service definition
4. Add volumes/networks as needed
5. Test: `make restart`

## Troubleshooting

### Build Failures

```bash
# Clear Docker cache and rebuild
docker system prune -a
make re
```

### Permission Issues

```bash
# Fix data directory permissions
sudo chown -R $USER:$USER ~/data/

# Check Docker socket permissions
sudo chmod 666 /var/run/docker.sock
```

### Network Issues

```bash
# Recreate network
docker network rm inception_all
make restart
```

### Database Connection Errors

1. Verify `.env` credentials match between services
2. Check MariaDB logs: `docker logs mariadb`
3. Ensure MariaDB started before WordPress: `docker ps`
