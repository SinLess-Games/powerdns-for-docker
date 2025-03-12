# PowerDNS Networking Configuration

This directory contains the configuration files and Docker Compose setup for deploying the PowerDNS components in your network. It leverages Docker Compose to run and manage the following services:

- **MySQL**: Database used by PowerDNS for storing DNS records and related information.
- **PDNS Authoritative**: The PowerDNS authoritative server that provides DNS resolution for your domains.
- **PowerDNS Admin**: A web-based management interface for PowerDNS.
- **Nginx**: A reverse proxy used to expose the PowerDNS Admin interface externally.

## File Structure

- **.env.example**: A template for environment variables. Copy this file to `.env` and update the values with your actual credentials.
- **.gitignore**: Ignores the persistent data directory (`.data/`).
- **docker-compose.yaml**: The Docker Compose file that defines all the services, networks, volumes, and healthchecks.
- **configs/**: Contains configuration files for the services (e.g., the custom Nginx configuration for PowerDNS Admin).

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup and Usage

1. **Configure Environment Variables**  
   - Copy the `.env.example` file to `.env`:
     ```bash
     cp .env.example .env
     ```
   - Edit `.env` to set your MySQL root password and PDNS API key:
     ```dotenv
     MYSQL_ROOT_PASSWORD="your_mysql_root_password"
     PDNS_API_KEY="your_pdns_api_key"
     ```

2. **Run the Services**  
   Start the services using Docker Compose:
   ```bash
   docker compose up -d --build
   ```
   This command will build and start the containers in detached mode.

3. **Health Checks and Logs**  
   Each service is configured with healthchecks:
   - MySQL uses `mysqladmin ping`.
   - PDNS Authoritative uses `pdns_control rping`.
   - PowerDNS Admin uses a curl command to check the web interface.
   - Nginx is set up to proxy requests to PowerDNS Admin.
   
   To view logs for troubleshooting, use:
   ```bash
   docker logs <container_name>
   ```

4. **Networking**  
   All containers are connected to the `pdns_network` (a bridge network). The PDNS Authoritative server is exposed on port **53** (both TCP and UDP) and PowerDNS Admin on port **8081**. Nginx listens on port **8000** inside the container and is mapped to port **8082** externally.

## Customization

- **Configuration Files**:  
  You can update the Nginx configuration (located in `configs/nginx-pdns-admin.conf`) to modify the proxy behavior for PowerDNS Admin.
  
- **Volumes**:  
  The persistent data for MySQL and PowerDNS Admin is stored in the local directories under `.data/`. These directories are mounted into the containers, ensuring that your DNS records and settings persist between container restarts.

## Troubleshooting

- **Environment Variables Not Loaded?**  
  Ensure you have copied and configured your `.env` file correctly.
  
- **Service Not Healthy?**  
  Check individual container logs using `docker logs <container_name>` and verify the healthcheck commands.
  
- **Networking Issues?**  
  Confirm that the `pdns_network` exists and is correctly configured as a bridge network. If needed, create or inspect the network using:
  ```bash
  docker network ls
  docker network inspect pdns_network
  ```

## Further Reading

- [PowerDNS Documentation](https://doc.powerdns.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)

---

This setup is designed to be secure and maintainable while providing a flexible platform for DNS resolution, domain management, and administration. Customize the configurations as needed to best fit your network architecture and requirements.

