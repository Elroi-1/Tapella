const { AppError } = require('./errorHandler');

function requireRole(...roles) {
  return (req, _res, next) => {
    if (!req.user) {
      return next(new AppError('Authentication required', 401, 'UNAUTHORIZED'));
    }
    if (!roles.includes(req.user.role)) {
      return next(new AppError('Forbidden', 403, 'FORBIDDEN'));
    }
    next();
  };
}

module.exports = { requireRole };
