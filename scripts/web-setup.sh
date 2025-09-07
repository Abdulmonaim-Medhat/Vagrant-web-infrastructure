#!/bin/bash

echo "=== Web Server Setup (Nginx + Node.js) ==="

# Update system packages
apt-get update -y

# Install Nginx
apt-get install -y nginx

# Install Node.js (using NodeSource repository for latest LTS)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs

# Install PM2 for process management
npm install -g pm2

# The /var/www/webapp directory will be mounted from host
# Install npm dependencies if package.json exists
if [ -f "/var/www/webapp/package.json" ]; then
    echo "Installing Node.js dependencies..."
    cd /var/www/webapp
    npm install
    
    echo "Starting application with PM2..."
    sudo -u vagrant pm2 start server.js --name "webapp"
    sudo -u vagrant pm2 startup
    sudo -u vagrant pm2 save
fi

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

echo "Web server setup completed!"
echo "App directory synced from host to /var/www/webapp"
