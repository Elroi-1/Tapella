const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const apiRoutes = require('./routes');
const { notFoundHandler, errorHandler } = require('./middleware/errorHandler');

function createApp() {
  const app = express();
  app.use(cors({ origin: true, credentials: true }));
  app.use(express.json({ limit: '5mb' }));
  app.use(morgan('dev'));

  app.use((req, res, next) => {
    req.requestId = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    res.setHeader('X-Request-Id', req.requestId);
    next();
  });

  app.use('/api/v1', apiRoutes);
  app.use(notFoundHandler);
  app.use(errorHandler);
  return app;
}

module.exports = { createApp };
