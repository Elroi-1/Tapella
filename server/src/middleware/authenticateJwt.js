const jwt = require('jsonwebtoken');
const { AppError } = require('./errorHandler');
const env = require('../config/env');

function authenticateJwt(req, _res, next) {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    return next(new AppError('Authentication required', 401, 'UNAUTHORIZED'));
  }
  const token = header.slice(7);
  try {
    const payload = jwt.verify(token, env.jwtSecret);
    req.user = { id: payload.sub, role: payload.role, email: payload.email };
    next();
  } catch {
    next(new AppError('Invalid or expired token', 401, 'INVALID_TOKEN'));
  }
}

function optionalAuth(req, _res, next) {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) return next();
  const token = header.slice(7);
  try {
    const payload = jwt.verify(token, env.jwtSecret);
    req.user = { id: payload.sub, role: payload.role, email: payload.email };
  } catch {
    /* ignore */
  }
  next();
}

module.exports = { authenticateJwt, optionalAuth };
