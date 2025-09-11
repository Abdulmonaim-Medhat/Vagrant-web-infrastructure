# Vagrant Web Infrastructure with Monitoring

A production-ready multi-VM web infrastructure setup using Vagrant, demonstrating Infrastructure as Code (IaC) principles with comprehensive monitoring.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Monitoring    │    │   Web Server    │    │    Database     │
│ (Prometheus +   │◄──►│ (Nginx+Node.js) │◄──►│  (PostgreSQL)   │
│   Grafana)      │    │                 │    │                 │
│ 192.168.20.102  │    │ 192.168.20.100  │    │ 192.168.20.101  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                       Node Exporters (System Metrics)
```

## Current Status: ✅ Full Infrastructure Operational

### Features Implemented
- [x] Multi-VM Vagrant setup with libvirt provider
- [x] PostgreSQL database with remote access configured
- [x] Node.js web application with Express framework  
- [x] Database connectivity and health checks
- [x] Automated provisioning scripts
- [x] Synced folders for development workflow
- [x] Prometheus monitoring server for metrics collection
- [x] Grafana dashboards for visualization
- [x] Node Exporter on all VMs for system metrics
- [x] Complete monitoring stack integration

## Quick Start

```bash
# Clone the repository
git clone https://github.com/Abdulmonaim-Medhat/Vagrant-web-infrastructure.git
cd vagrant-web-infrastructure

# Start the complete infrastructure
vagrant up

# Test the services
curl http://localhost:3001          # Web application
curl http://localhost:3001/health   # Database health check
curl http://localhost:9090          # Prometheus
# Visit http://localhost:3000       # Grafana (admin/admin)
```

## Service Access

| Service | Local URL | VM IP | Description |
|---------|-----------|--------|-------------|
| Web Application | http://localhost:3001 | http://192.168.20.100:3000 | Node.js/Express app with DB connectivity |
| Grafana | http://localhost:3000 | http://192.168.20.102:3000 | Monitoring dashboards (admin/admin) |
| Prometheus | http://localhost:9090 | http://192.168.20.102:9090 | Metrics collection and querying |

## VM Details

| VM | IP Address | Role | Resources | Key Services |
|----|------------|------|-----------|--------------|
| web | 192.168.20.100 | Web Server | 1GB RAM, 1 CPU | Nginx, Node.js, PM2, Node Exporter |
| db | 192.168.20.101 | Database | 1GB RAM, 1 CPU | PostgreSQL, Node Exporter |
| monitoring | 192.168.20.102 | Monitoring | 1GB RAM, 1 CPU | Prometheus, Grafana, Node Exporter |

## Technology Stack

- **Infrastructure**: Vagrant + libvirt
- **Web Server**: Nginx + Node.js/Express
- **Database**: PostgreSQL 14
- **Monitoring**: Prometheus + Grafana
- **Metrics**: Node Exporter (system metrics)
- **Process Management**: PM2
- **Provisioning**: Shell scripts with automated setup

## Monitoring Features

### Metrics Collected
- **System Metrics**: CPU, Memory, Disk, Network (all VMs)
- **Application Metrics**: Database connectivity, response times
- **Database Metrics**: PostgreSQL connection status
- **Infrastructure Metrics**: Service health and availability

### Pre-configured Dashboards
- System overview for all VMs
- Database performance monitoring
- Web application performance
- Infrastructure health status

## Development Workflow

The application code is synced from `./app` to `/var/www/webapp` on the web server VM, enabling real-time development. Configuration files are synced from `./config` to `/vagrant/config` on relevant VMs.

### Application Endpoints

- `GET /` - Main application page with infrastructure overview
- `GET /health` - Database connectivity and system health check

## Prerequisites

- Vagrant installed
- libvirt provider configured
- At least 4GB RAM available for VMs
- Network ports 3000, 3001, 9090 available on host

## Project Structure

```
vagrant-web-infrastructure/
├── Vagrantfile                  # VM definitions and configuration
├── README.md                    # This file
├── scripts/                     # Provisioning scripts
│   ├── db-setup.sh             # PostgreSQL + Node Exporter setup
│   ├── web-setup.sh            # Nginx + Node.js + Node Exporter setup
│   └── monitoring-setup.sh     # Prometheus + Grafana + Node Exporter
├── config/                     # Configuration files
│   ├── prometheus/             # Prometheus monitoring configuration
│   │   └── prometheus.yml      # Scraping targets and jobs
│   ├── grafana/               # Grafana configurations (optional)
│   └── nginx/                 # Nginx configurations (future)
└── app/                       # Node.js web application
    ├── package.json           # Node.js dependencies
    └── server.js              # Express application with DB connectivity
```

## Useful Commands

```bash
# VM Management
vagrant status                   # Check VM status
vagrant up                      # Start all VMs
vagrant up web                  # Start specific VM
vagrant ssh web                 # SSH into web server
vagrant reload monitoring      # Reload monitoring VM with new config

# Service Management (inside VMs)
sudo systemctl status prometheus    # Check Prometheus
sudo systemctl status grafana-server # Check Grafana
sudo -u vagrant pm2 list           # Check Node.js app
sudo systemctl status postgresql   # Check database

# Monitoring
curl http://localhost:9090/targets  # Check Prometheus targets
curl http://localhost:3001/health   # Application health check
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure ports 3000, 3001, 9090 are not in use
2. **VM networking**: Check `sudo virsh net-list --all` and start default network if needed
3. **Service not starting**: Check logs with `sudo journalctl -u <service-name>`
4. **Synced folders**: Verify files exist in `/var/www/webapp` and `/vagrant/config`

### Health Checks

```bash
# Check all services are running
vagrant ssh web && sudo -u vagrant pm2 list && exit
vagrant ssh db && sudo systemctl status postgresql && exit  
vagrant ssh monitoring && sudo systemctl status prometheus grafana-server && exit
```

## Production Considerations

This setup demonstrates production patterns including:
- Multi-tier architecture separation
- Automated infrastructure provisioning  
- Comprehensive monitoring and alerting
- Health check endpoints
- Proper service management
- Security considerations (isolated VMs, proper users)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test with `vagrant up`
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Built with Vagrant for infrastructure automation
- Prometheus and Grafana for monitoring excellence
- PostgreSQL for reliable data persistence
- Node.js ecosystem for modern web development
