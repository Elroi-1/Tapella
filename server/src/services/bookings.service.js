const { prisma } = require('../db/database');
const { AppError } = require('../middleware/errorHandler');
const VALID_TRANSITIONS = {
  pending: ['accepted', 'rejected', 'cancelled'],
  accepted: ['completed', 'rejected'],
};

function mapBooking(booking) {
  if (!booking) return null;
  return {
    id: booking.id,
    listingId: booking.listingId,
    listingTitle: booking.listing?.title || 'Service',
    customerId: booking.customerId,
    customerName: booking.customer?.displayName || 'Customer',
    customerPhoto: booking.customer?.profileImage || null,
    providerId: booking.providerId,
    providerName: booking.provider?.displayName || 'Provider',
    providerPhoto: booking.provider?.profileImage || null,
    status: booking.status,
    scheduledDate: booking.scheduledDate,
    notes: booking.notes,
    amountEtb: booking.amountEtb,
    createdAt: booking.createdAt.toISOString(),
    updatedAt: booking.updatedAt.toISOString(),
  };
}

async function create(customerId, { listingId, scheduledDate, notes }) {
  const listing = await prisma.listing.findUnique({
    where: { id: listingId }
  });
  
  if (!listing || listing.deletedAt) {
    throw new AppError('Listing not found', 404, 'NOT_FOUND');
  }

  const booking = await prisma.booking.create({
    data: {
      listingId,
      customerId,
      providerId: listing.providerId,
      status: 'pending',
      scheduledDate: scheduledDate || null,
      notes: notes || '',
      amountEtb: listing.priceEtb || 0,
    },
    include: {
      listing: { select: { title: true } },
      customer: { select: { displayName: true, profileImage: true } },
      provider: { select: { displayName: true, profileImage: true } }
    }
  });

  return mapBooking(booking);
}

async function listCustomer(customerId) {
  const bookings = await prisma.booking.findMany({
    where: { customerId },
    include: {
      listing: { select: { title: true } },
      customer: { select: { displayName: true, profileImage: true } },
      provider: { select: { displayName: true, profileImage: true } }
    },
    orderBy: { createdAt: 'desc' }
  });

  return bookings.map(mapBooking);
}

async function listIncoming(providerId) {
  const bookings = await prisma.booking.findMany({
    where: { providerId, status: 'pending' },
    include: {
      listing: { select: { title: true } },
      customer: { select: { displayName: true, profileImage: true } },
      provider: { select: { displayName: true, profileImage: true } }
    },
    orderBy: { createdAt: 'desc' }
  });

  return bookings.map(mapBooking);
}

async function listHistory(providerId) {
  const bookings = await prisma.booking.findMany({
    where: {
      providerId,
      status: { in: ['accepted', 'completed', 'rejected', 'cancelled'] }
    },
    include: {
      listing: { select: { title: true } },
      customer: { select: { displayName: true, profileImage: true } },
      provider: { select: { displayName: true, profileImage: true } }
    },
    orderBy: { updatedAt: 'desc' }
  });

  return bookings.map(mapBooking);
}

async function updateStatus(bookingId, providerId, newStatus, additionalData = {}) {
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId }
  });

  if (!booking) throw new AppError('Booking not found', 404, 'NOT_FOUND');
  if (booking.providerId !== providerId) {
    throw new AppError('Forbidden', 403, 'FORBIDDEN');
  }

  const allowed = VALID_TRANSITIONS[booking.status] || [];
  if (!allowed.includes(newStatus)) {
    throw new AppError(`Cannot transition from ${booking.status} to ${newStatus}`, 409, 'INVALID_TRANSITION');
  }

  const updatedBooking = await prisma.booking.update({
    where: { id: bookingId },
    data: { status: newStatus, ...additionalData },
    include: {
      listing: { select: { title: true } },
      customer: { select: { displayName: true } },
      provider: { select: { displayName: true } }
    }
  });

  return mapBooking(updatedBooking);
}

async function complete(bookingId, providerId, amountEtb) {
  const data = amountEtb ? { amountEtb: parseFloat(amountEtb) } : {};
  return updateStatus(bookingId, providerId, 'completed', data);
}

async function cancelByCustomer(bookingId, customerId) {
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId }
  });

  if (!booking) throw new AppError('Booking not found', 404, 'NOT_FOUND');
  if (booking.customerId !== customerId) {
    throw new AppError('Forbidden', 403, 'FORBIDDEN');
  }
  if (booking.status !== 'pending') {
    throw new AppError('Only pending requests can be cancelled', 409, 'INVALID_TRANSITION');
  }

  const updatedBooking = await prisma.booking.update({
    where: { id: bookingId },
    data: { status: 'cancelled' },
    include: {
      listing: { select: { title: true } },
      customer: { select: { displayName: true } },
      provider: { select: { displayName: true } }
    }
  });

  return mapBooking(updatedBooking);
}

module.exports = {
  create,
  listCustomer,
  listIncoming,
  listHistory,
  updateStatus,
  complete,
  cancelByCustomer,
  mapBooking,
};
