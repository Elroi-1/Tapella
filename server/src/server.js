const { createApp } = require('./app');
const { initDatabase } = require('./db/database');
const { seedIfEmpty } = require('./db/seed');
const env = require('./config/env');

async function start() {
  await initDatabase();
  await seedIfEmpty();

  const app = createApp();
  const server = app.listen(env.port, () => {
    console.log(`Tapella API running on http://localhost:${env.port}/api/v1`);
  });

  server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      console.error(
        `\nPort ${env.port} is already in use. Either:\n` +
          `  1. Stop the other process:  netstat -ano | findstr :${env.port}  then  taskkill /PID <pid> /F\n` +
          `  2. Use a different port:    set PORT=3001  && npm run dev\n`,
      );
      process.exit(1);
    }
    console.error('Server error:', err);
    process.exit(1);
  });
}

start().catch((err) => {
  console.error('Failed to start server:', err);
  process.exit(1);
});
