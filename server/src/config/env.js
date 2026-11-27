require('dotenv').config();

const nodeEnv = process.env.NODE_ENV || 'development';
const isProduction = nodeEnv === 'production';

if (isProduction && (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET)) {
  throw new Error('JWT_SECRET and JWT_REFRESH_SECRET must be set in production');
}

module.exports = {
  port: parseInt(process.env.PORT || '3000', 10),
  jwtSecret: process.env.JWT_SECRET || 'tapella-dev-secret',
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET || 'tapella-dev-refresh-secret',
  accessExpiresIn: '15m',
  refreshExpiresIn: '7d',
  nodeEnv,
};
