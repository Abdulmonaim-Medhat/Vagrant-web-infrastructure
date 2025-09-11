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

echo "Node Exporter installed on web server"
