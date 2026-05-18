require('dotenv').config();

module.exports = {
  port: parseInt(process.env.PORT || '3000', 10),
  jwtSecret: process.env.JWT_SECRET || 'tapella-dev-secret',
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET || 'tapella-dev-refresh-secret',
  accessExpiresIn: '15m',
  refreshExpiresIn: '7d',
  nodeEnv: process.env.NODE_ENV || 'development',
};
