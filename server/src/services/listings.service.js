const { prisma } = require("../db/database");
const { AppError } = require("../middleware/errorHandler");

function mapListing(listing) {
  if (!listing) return null;
  return {
    id: listing.id,
    providerId: listing.providerId,
    providerName: listing.provider?.displayName || "Provider",
    providerPhoto: listing.provider?.profileImage || null,
    title: listing.title,
    description: listing.description,
    category: listing.category,
    priceEtb: listing.priceEtb,
    location: listing.location,
    phone: listing.phone,
    ratingAvg: listing.ratingAvg,
    reviewCount: listing.reviewCount,
    createdAt: listing.createdAt.toISOString(),
    updatedAt: listing.updatedAt.toISOString(),
  };
}

async function listPublic({ search, category }) {
  const where = {
    deletedAt: null,
  };

  if (category) {
    where.category = category;
  }

  if (search) {
    where.OR = [
      { title: { contains: search } },
      { description: { contains: search } },
      { location: { contains: search } },
    ];
  }

  const listings = await prisma.listing.findMany({
    where,
    include: {
      provider: {
        select: { displayName: true, profileImage: true },
      },
    },
    orderBy: [{ ratingAvg: "desc" }, { createdAt: "desc" }],
  });

  return listings.map(mapListing);
}

async function getById(id) {
  const listing = await prisma.listing.findUnique({
    where: { id },
    include: {
      provider: {
        select: { displayName: true, profileImage: true },
      },
    },
  });

  if (!listing || listing.deletedAt) {
    throw new AppError("Listing not found", 404, "NOT_FOUND");
  }

  return mapListing(listing);
}

async function listMine(providerId) {
  const listings = await prisma.listing.findMany({
    where: {
      providerId,
      deletedAt: null,
    },
    include: {
      provider: {
        select: { displayName: true, profileImage: true },
      },
    },
    orderBy: { createdAt: "desc" },
  });

  return listings.map(mapListing);
}

async function create(providerId, body) {
  const listing = await prisma.listing.create({
    data: {
      providerId,
      title: body.title,
      description: body.description || "",
      category: body.category,
      priceEtb: body.priceEtb || 0,
      location: body.location || "",
      phone: body.phone || "",
    },
    include: {
      provider: {
        select: { displayName: true, profileImage: true },
      },
    },
  });

  return mapListing(listing);
}

async function update(id, body) {
  const existing = await prisma.listing.findUnique({ where: { id } });
  if (!existing || existing.deletedAt) {
    throw new AppError("Listing not found", 404, "NOT_FOUND");
  }

  const listing = await prisma.listing.update({
    where: { id },
    data: {
      title: body.title ?? existing.title,
      description: body.description ?? existing.description,
      category: body.category ?? existing.category,
      priceEtb: body.priceEtb ?? existing.priceEtb,
      location: body.location ?? existing.location,
      phone: body.phone ?? existing.phone,
    },
    include: {
      provider: {
        select: { displayName: true, profileImage: true },
      },
    },
  });

  return mapListing(listing);
}

async function remove(id) {
  await prisma.listing.delete({
    where: { id },
  });
  return { deleted: true };
}

async function recalculateRating(listingId) {
  const aggregates = await prisma.review.aggregate({
    where: { listingId },
    _avg: { rating: true },
    _count: { _all: true },
  });

  await prisma.listing.update({
    where: { id: listingId },
    data: {
      ratingAvg: aggregates._avg.rating || 0,
      reviewCount: aggregates._count._all || 0,
    },
  });
}

module.exports = {
  listPublic,
  getById,
  listMine,
  create,
  update,
  remove,
  recalculateRating,
  mapListing,
};
