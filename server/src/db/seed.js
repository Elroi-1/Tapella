const bcrypt = require('bcryptjs');
const { prisma } = require('./database');

async function seedIfEmpty() {
  const count = await prisma.user.count();
  if (count > 0) return;

  const hash = await bcrypt.hash('password123', 10);

  const provider = await prisma.user.create({
    data: {
      email: 'provider@tapella.com',
      passwordHash: hash,
      role: 'provider',
      displayName: 'Saron Kiflu',
      phone: '0911000001',
    },
  });

  const customer = await prisma.user.create({
    data: {
      email: 'customer@tapella.com',
      passwordHash: hash,
      role: 'customer',
      displayName: 'Naomi M',
      phone: '0911000002',
    },
  });

  const listings = [
    {
      title: 'Master Plumber',
      description: 'Master of pipes, pressure, and precision',
      category: 'Plumbing',
      priceEtb: 500,
      location: 'Megenagna',
    },
    {
      title: 'Premium Housekeeping',
      description: 'Reliable cleaning, laundry, and home organization',
      category: 'Cleaning',
      priceEtb: 350,
      location: 'Bole',
    },
    {
      title: 'Web Development',
      description: 'Website developer, maintainer, and tech specialist',
      category: 'Development',
      priceEtb: 1200,
      location: 'Mexico',
    },
  ];

  for (const l of listings) {
    await prisma.listing.create({
      data: {
        providerId: provider.id,
        title: l.title,
        description: l.description,
        category: l.category,
        priceEtb: l.priceEtb,
        location: l.location,
        phone: '0911000001',
        ratingAvg: 4.8,
        reviewCount: 12,
      },
    });
  }

  console.log('Seeded demo users: provider@tapella.com / customer@tapella.com (password123)');
}

module.exports = { seedIfEmpty };
