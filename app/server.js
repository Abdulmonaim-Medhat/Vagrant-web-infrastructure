const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// PostgreSQL connection
const pool = new Pool({
  user: 'webapp_user',
  host: '192.168.20.101',
  database: 'webapp_db',
  password: 'webapp_pass',
  port: 5432,
});

// Test database connection
pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error('Database connection failed:', err);
  } else {
    console.log('Database connected successfully:', res.rows[0].now);
  }
});

// Routes
app.get('/', (req, res) => {
  res.send(`
    <h1>Vagrant Web Infrastructure Demo</h1>
    <p>Web Server: 192.168.20.100</p>
    <p>Database: 192.168.20.101</p>
    <p>Load Balancer: 192.168.20.102</p>
    <a href="/health">Check Database Health</a>
  `);
});

app.get('/health', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW() as timestamp, version() as pg_version');
    res.json({
      status: 'healthy',
      database: 'connected',
      timestamp: result.rows[0].timestamp,
      postgresql_version: result.rows[0].pg_version
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: err.message
    });
  }
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Web application running on http://0.0.0.0:${port}`);
});
