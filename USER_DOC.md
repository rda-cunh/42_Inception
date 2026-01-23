# User Documentation

This guide explains how to use the Inception infrastructure as an end user.

## Services Provided

The Inception stack provides the following services:

- **WordPress Website**: A fully functional content management system accessible via web browser
- **NGINX Web Server**: Secure HTTPS access with TLS 1.2 encryption
- **MariaDB Database**: Persistent data storage for WordPress content
- **Admin Panel**: WordPress dashboard for content and user management

## Starting and Stopping the Project

### Starting the Infrastructure

```bash
# Navigate to the project directory
cd /path/to/42_Inception

# Start all services
make
```

The system will:
1. Create data directories (`~/data/database` and `~/data/wordpress_files`)
2. Add `rda-cunh.42.fr` to `/etc/hosts` (requires sudo)
3. Build Docker images
4. Start all containers

**Success message**: `✓ Inception is running at https://rda-cunh.42.fr`

### Stopping the Infrastructure

```bash
# Stop containers (preserves data)
make stop

# Stop and remove containers (preserves volumes)
make down
```

### Restarting After Changes

```bash
# Quick restart
make restart
```

## Accessing the Website

### Public Website
- **URL**: `https://rda-cunh.42.fr`
- **Access**: Open in any web browser
- **Note**: You'll see a security warning (self-signed certificate) - click "Advanced" → "Proceed"

### Administration Panel
- **URL**: `https://rda-cunh.42.fr/wp-admin`
- **Login**: Use administrator credentials (see below)

## Managing Credentials

**⚠️ Security Requirement**: Credentials were **not** stored in the repository during delivery. The `.env` file is excluded and must be added manually.

### Setup

1. Create or your add the environment file

2. On the public github repository the environment file is already present at the rooot and you can edit it, mantaining the info template.

## Checking Service Status

### Quick Status Check

```bash
# View all running containers
make status
```

This displays:
- Container status and health
- Docker images
- Active volumes
- Network configuration

### Detailed Container Logs

```bash
# Follow logs in real-time
make logs

# View logs for specific service
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### Manual Service Verification

1. **NGINX**: Visit `https://rda-cunh.42.fr` - should display WordPress homepage
2. **WordPress**: Login at `/wp-admin` - should show dashboard
3. **MariaDB**: Check database connection from WordPress dashboard → Site Health

### Container Health Check

```bash
# List running containers
docker ps

# Should show all three containers with "Up" status:
# - nginx
# - wordpress  
# - mariadb
```

## Troubleshooting

### Website Not Loading
1. Check containers are running: `docker ps`
2. Verify host entry exists: `grep rda-cunh.42.fr /etc/hosts`
3. Check logs: `make logs`

### Cannot Login to WordPress
1. Verify credentials in `srcs/.env`
2. Check database connection: `docker logs mariadb`
3. Restart services: `make restart`

### Port 443 Already in Use
```bash
# Find process using port 443
sudo lsof -i :443

# Stop conflicting service or change port in docker-compose.yml
```

## Data Persistence

All data is stored in `~/data/`:
- `~/data/database/` - MariaDB database files
- `~/data/wordpress_files/` - WordPress installation and uploads

**Backup**: Copy these directories to preserve your data.

**Restore**: Replace directories with backups before running `make`.