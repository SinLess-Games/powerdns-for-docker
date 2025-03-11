FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    pdns-server \
    pdns-backend-mysql \
    python3 \
    python3-pip \
    git \
    nginx \
    && apt-get clean

# Install PowerDNS-Admin
WORKDIR /opt
RUN git clone https://github.com/PowerDNS-Admin/PowerDNS-Admin.git
WORKDIR /opt/PowerDNS-Admin
RUN pip3 install -r requirements.txt

# Copy configuration files
COPY pdns.conf /etc/powerdns/pdns.conf
COPY config.py /opt/PowerDNS-Admin/config.py
COPY nginx.conf /etc/nginx/nginx.conf

# Expose necessary ports
EXPOSE 53/tcp 53/udp 80 443

# Start services
CMD service mariadb start && service pdns start && service nginx start && tail -f /dev/null
