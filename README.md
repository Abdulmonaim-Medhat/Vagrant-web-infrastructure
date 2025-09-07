# Vagrant Web Infrastructure

A production-ready multi-VM web infrastructure setup using Vagrant, demonstrating Infrastructure as Code (IaC) principles.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Load Balancer  │    │   Web Server    │    │    Database     │
│   (HAProxy)     │◄──►│ (Nginx+Node.js) │◄──►│  (PostgreSQL)   │
│ 192.168.20.102  │    │ 192.168.20.100  │    │ 192.168.20.101  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Current Status: ✅ Database + Web Server Working

### Features Implemented
- [x] Multi-VM Vagrant setup with libvirt provider
- [x] PostgreSQL database with remote access configured
- [x] Node.js web application with Express framework  
- [x] Database connectivity and health checks
- [x] Automated provisioning scripts
- [x] Synced folders for development workflow
- [ ] HAProxy load balancer (in progress)
- [ ] System monitoring (planned)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/Abdulmonaim-Medhat/Vagrant-web-infrastructure.git
cd vagrant-web-infrastructure

# Start the infrastructure
vagrant up

# Test the application
curl http://192.168.20.100:3000
curl http://192.168.20.100:3000/health
```

## VM Details

| VM | IP Address | Role | Resources |
|----|------------|------|-----------|
| web | 192.168.20.100 | Web Server (Nginx + Node.js) | 1GB RAM, 1 CPU |
| db | 192.168.20.101 | PostgreSQL Database | 1GB RAM, 1 CPU |
| lb | 192.168.20.102 | HAProxy Load Balancer | 512MB RAM, 1 CPU |

## Technology Stack

- **Infrastructure**: Vagrant + libvirt
- **Web Server**: Nginx + Node.js/Express
- **Database**: PostgreSQL 14
- **Load Balancer**: HAProxy (coming soon)
- **Process Management**: PM2

## Development

The application code is synced from `./app` to `/var/www/webapp` on the web server VM, enabling real-time development.

### Application Endpoints

- `GET /` - Main application page
- `GET /health` - Database connectivity health check

## Prerequisites

- Vagrant installed
- libvirt provider configured
- At least 3GB RAM available for VMs

## Project Structure

```
vagrant-web-infrastructure/
├── Vagrantfile              # VM definitions and configuration
├── README.md                # This file
├── scripts/                 # Provisioning scripts
│   ├── db-setup.sh         # PostgreSQL installation and configuration
│   ├── web-setup.sh        # Nginx + Node.js setup
│   ├── lb-setup.sh         # HAProxy setup (in progress)
│   └── monitoring-setup.sh # System monitoring (planned)
├── config/                 # Configuration files
│   ├── haproxy/           # HAProxy configurations
│   ├── nginx/             # Nginx configurations (planned)
│   └── postgresql/        # PostgreSQL configurations (planned)
└── app/                   # Node.js web application
    ├── package.json       # Node.js dependencies
    └── server.js          # Express application
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `vagrant up`
5. Submit a pull request

## License

MIT License
