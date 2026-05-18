require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const { PrismaLibSql } = require('@prisma/adapter-libsql');

const dbUrl = process.env.DATABASE_URL || 'file:./data/tapella.db';

const adapter = new PrismaLibSql({
  url: dbUrl,
});
const prisma = new PrismaClient({ adapter });

async function initDatabase() {
  try {
    // Explicit query check instead of $connect to ensure engine & adapter are happy
    await prisma.$queryRawUnsafe('SELECT 1');
    console.log('Database connected via Prisma (LibSQL)');
  } catch (error) {
    console.error('Failed to connect to database', error);
    process.exit(1);
  }
}

// For backward compatibility during migration
function run() { throw new Error('Use prisma client instead of db.run'); }
function get() { throw new Error('Use prisma client instead of db.get'); }
function all() { throw new Error('Use prisma client instead of db.all'); }
function persist() { /* No-op with Prisma */ }

module.exports = { initDatabase, prisma, run, get, all, persist };
