# Inception

*This project has been created as part of the 42 curriculum by rda-cunh.*

## Description

Inception is a system administration project that builds a small-scale infrastructure using Docker containerization. The goal is to create a multi-service web hosting environment following best practices for isolation, security, and persistence.

The infrastructure consists of three core services running in separate containers: NGINX as a reverse proxy with TLS encryption, WordPress with php-fpm for content management, and MariaDB for database storage. All services communicate through a dedicated Docker network and use persistent volumes to ensure data durability.

## Instructions

### Prerequisites
- Debian-based virtual machine
- Docker and Docker Compose installed
- Sudo privileges for host file modification

### Building and Running
```bash
# Build and start the entire infrastructure
make

# Stop containers without removing them
make stop

# Restart the infrastructure
make restart

# View container logs
make logs

# Check infrastructure status
make status
```

### Accessing the Services
- Website: `https://rda-cunh.42.fr`
- WordPress Admin: `https://rda-cunh.42.fr/wp-admin`

### Cleanup
```bash
# Stop containers and remove volumes
make clean

# Complete cleanup (images, data, host entry)
make fclean
```

## Project Description

### Docker Usage

This project uses Docker containerization to isolate services, ensuring consistency across environments and simplifying deployment. Each service runs in its own container built from custom Dockerfiles based on Debian.

**Key Design Choices:**
- **Base Image**: Debian (penultimate stable version: bookworm) chosen for stability, extensive package ecosystem, and production-readiness
- **Network**: Bridge network (`all`) enables container-to-container communication while maintaining isolation
- **Entry Point**: NGINX container exclusively handles external traffic on port 443 with TLS 1.2
- **Persistence**: Named volumes with bind mounts to `~/data/` for easy backup and access
- **Configuration**: Environment variables stored in `.env` file 

### Virtual Machines vs Docker

| Aspect | Virtual Machines | Docker |
|--------|-----------------|--------|
| **Resource Usage** | High overhead (full OS per VM) | Minimal overhead (shared kernel) |
| **Startup Time** | Minutes | Seconds |
| **Isolation** | Complete hardware virtualization | Process-level isolation |
| **Portability** | Limited (large image sizes) | Excellent (lightweight images) |
| **Use Case** | Multiple OS environments, strong isolation needs | Microservices, development environments, CI/CD |

**Docker is ideal for this project** because it provides sufficient isolation for web services while maintaining efficiency and portability.

### Secrets vs Environment Variables

| Feature | Secrets | Environment Variables |
|---------|---------|----------------------|
| **Security** | Encrypted at rest, transmitted securely | Stored as plaintext |
| **Visibility** | Mounted as files, not in container inspect | Visible in `docker inspect`, logs |
| **Rotation** | Supports updates without rebuilds | Requires container restart |
| **Complexity** | Requires orchestration (Swarm/Kubernetes) | Simple file-based configuration |

**This project uses environment variables** stored in `.env` files for simplicity in a development/learning context. For production environments, Docker secrets would provide better security.

### Docker Network vs Host Network

| Network Mode | Description | Advantages | Disadvantages |
|-------------|-------------|------------|---------------|
| **Bridge (Docker Network)** | Isolated network for containers | Port mapping control, container isolation, DNS resolution | Slight performance overhead |
| **Host** | Container uses host's network stack | Maximum performance, no port mapping | No isolation, port conflicts, security risks |

**This project uses bridge networking** to enable inter-container communication while maintaining network isolation from the host system.

### Docker Volumes vs Bind Mounts

| Type | Path Management | Use Case | Portability |
|------|----------------|----------|-------------|
| **Volumes** | Docker-managed (`/var/lib/docker/volumes/`) | Production data, managed by Docker | High (works across systems) |
| **Bind Mounts** | Host path specified explicitly | Development, direct file access | Low (host-specific paths) |

**This project uses volumes with bind mount configuration** (`device: ~/data/`), combining Docker volume management with explicit host paths for easier development access and backup.

## Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
- [Debian Releases](https://www.debian.org/releases/)
- [PHP-FPM Supported Versions](https://www.php.net/supported-versions.php)

### Tutorials and Guides
- [Docker Installation on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
- [Docker Video Series](https://www.youtube.com/playlist?list=PLViOsriojeLrdw5VByn96gphHFxqH3O_N)
- [Inception Guide by imyzf](https://medium.com/@imyzf/inception-3979046d90a0)
- [Inception Guide Part I by ssterdev](https://medium.com/@ssterdev/inception-guide-42-project-part-i-7e3af15eb671)

### AI Usage

AI tools were used throughout the project for:

- **Concept Research**: Understanding Docker networking, volumes, and orchestration patterns
- **Idea Discussion**: Evaluating different architectural approaches and design decisions
- **Debugging**: Troubleshooting container startup issues, network connectivity, and configuration errors
- **Documentation Organization**: Structuring README files and technical comparisons
- **Code Review**: Identifying potential security issues and best practice violations

All AI-generated content was reviewed, tested, and adapted to ensure correctness and compliance with project requirements.
