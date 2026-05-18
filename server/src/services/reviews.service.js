const { prisma } = require('../db/database');
const { AppError } = require('../middleware/errorHandler');
const listingsService = require('./listings.service');

function mapReview(review) {
  if (!review) return null;
  return {
    id: review.id,
    bookingId: review.bookingId,
    listingId: review.listingId,
    customerId: review.customerId,
    customerName: review.customer?.displayName || 'Customer',
    customerPhoto: review.customer?.profileImage || null,
    rating: review.rating,
    comment: review.comment,
    createdAt: review.createdAt.toISOString(),
  };
}

async function create(customerId, bookingId, { rating, comment }) {
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId }
  });

  if (!booking) throw new AppError('Booking not found', 404, 'NOT_FOUND');
  if (booking.customerId !== customerId) {
    throw new AppError('Forbidden', 403, 'FORBIDDEN');
  }
  if (booking.status !== 'completed') {
    throw new AppError('Can only review completed bookings', 409, 'BOOKING_NOT_COMPLETED');
  }

  const existing = await prisma.review.findUnique({
    where: { bookingId }
  });
  if (existing) throw new AppError('Review already exists', 409, 'REVIEW_EXISTS');

  const review = await prisma.review.create({
    data: {
      bookingId,
      listingId: booking.listingId,
      customerId,
      providerId: booking.providerId,
      rating,
      comment: comment || '',
    },
    include: {
      customer: { select: { displayName: true, profileImage: true } }
    }
  });

  await listingsService.recalculateRating(booking.listingId);
  return mapReview(review);
}

async function listByListing(listingId) {
  const reviews = await prisma.review.findMany({
    where: { listingId },
    include: {
      customer: { select: { displayName: true, profileImage: true } }
    },
    orderBy: { createdAt: 'desc' }
  });

  return reviews.map(mapReview);
}

async function listByProvider(providerId) {
  const reviews = await prisma.review.findMany({
    where: { providerId },
    include: {
      customer: { select: { displayName: true, profileImage: true } }
    },
    orderBy: { createdAt: 'desc' }
  });

  return reviews.map(mapReview);
}

module.exports = { create, listByListing, listByProvider, mapReview };
