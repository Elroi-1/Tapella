const { prisma } = require('../db/database');
const { AppError } = require('./errorHandler');

async function listingOwnership(req, _res, next) {
  try {
    const listing = await prisma.listing.findUnique({
      where: { id: req.params.id }
    });

    if (!listing || listing.deletedAt) {
      return next(new AppError('Listing not found', 404, 'NOT_FOUND'));
    }
    if (listing.providerId !== req.user.id) {
      return next(new AppError('You do not own this listing', 403, 'FORBIDDEN'));
    }
    req.listing = listing;
    next();
  } catch (e) {
    next(e);
  }
}

module.exports = { listingOwnership };
