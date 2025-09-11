#!/bin/bash

echo "=== PostgreSQL Database Setup ==="

# Update system packages
apt-get update -y

# Install PostgreSQL
apt-get install -y postgresql postgresql-contrib

# Start and enable PostgreSQL service
systemctl start postgresql
systemctl enable postgresql

# Create application database and user
sudo -u postgres psql -c "CREATE DATABASE webapp_db;"
sudo -u postgres psql -c "CREATE USER webapp_user WITH PASSWORD 'webapp_pass';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE webapp_db TO webapp_user;"

# Configure PostgreSQL for remote connections
echo "Configuring PostgreSQL for network access..."

# Update postgresql.conf
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/14/main/postgresql.conf

# Update pg_hba.conf for our network
echo "host    webapp_db    webapp_user    192.168.20.0/24    md5" >> /etc/postgresql/14/main/pg_hba.conf

# Restart PostgreSQL
systemctl restart postgresql

echo "PostgreSQL setup completed!"
echo "Database: webapp_db"
echo "User: webapp_user"
echo "Access from: 192.168.20.0/24 network"

echo "=== Installing Node Exporter for monitoring ==="

# Download and install Node Exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvf node_exporter-1.5.0.linux-amd64.tar.gz
cp node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.5.0.linux-amd64*

# Create node_exporter service
cat > /etc/systemd/system/node_exporter.service << 'NODE_SERVICE'
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=vagrant
Group=vagrant
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
NODE_SERVICE

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

echo "Node Exporter installed on database server"
