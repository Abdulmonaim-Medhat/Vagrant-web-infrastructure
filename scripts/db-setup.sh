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
