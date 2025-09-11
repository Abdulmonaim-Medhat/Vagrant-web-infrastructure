#!/bin/bash

echo "=== Nginx Load Balancer Setup ==="

# Update system packages
apt-get update -y

# Install Nginx
apt-get install -y nginx

# Remove default site
rm -f /etc/nginx/sites-enabled/default

# Copy our load balancer configuration
cp /vagrant/config/nginx/lb.conf /etc/nginx/sites-available/lb.conf

# Enable our site
ln -s /etc/nginx/sites-available/lb.conf /etc/nginx/sites-enabled/lb.conf

# Test nginx configuration
nginx -t

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

echo "Nginx Load Balancer setup completed!"
echo "Load balancer running on port 80"
echo "Backend: 192.168.20.100:3000"
echo "Health check: http://192.168.20.102/lb-health"
