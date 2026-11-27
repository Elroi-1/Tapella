require('dotenv').config();
const { execFileSync } = require('child_process');
const path = require('path');
const { PrismaClient } = require('@prisma/client');
const { PrismaPg } = require('@prisma/adapter-pg');
const { Pool } = require('pg');

const dbUrl = process.env.DB_URL || process.env.DATABASE_URL;
const pool = new Pool({ connectionString: dbUrl });
const prisma = new PrismaClient({ adapter: new PrismaPg(pool) });

function syncSchema() {
  const binName = process.platform === 'win32' ? 'prisma.cmd' : 'prisma';
  const prismaBin = path.resolve(__dirname, '..', '..', 'node_modules', '.bin', binName);
  execFileSync(prismaBin, ['db', 'push'], {
    stdio: 'inherit',
    env: process.env,
    shell: process.platform === 'win32',
  });
}

async function initDatabase() {
  try {
    syncSchema();
    await prisma.$connect();
    console.log('Database connected via Prisma (PostgreSQL)');
  } catch (error) {
    console.error('Failed to connect to database', error);
    process.exit(1);
  }
}

module.exports = { initDatabase, prisma };
