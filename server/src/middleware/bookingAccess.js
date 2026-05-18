const { prisma } = require('../db/database');
const { AppError } = require('./errorHandler');

async function bookingAccess(req, _res, next) {
  try {
    const booking = await prisma.booking.findUnique({
      where: { id: req.params.id }
    });

    if (!booking) {
      return next(new AppError('Booking not found', 404, 'NOT_FOUND'));
    }
    const isCustomer = req.user.role === 'customer' && booking.customerId === req.user.id;
    const isProvider = req.user.role === 'provider' && booking.providerId === req.user.id;
    if (!isCustomer && !isProvider) {
      return next(new AppError('Forbidden', 403, 'FORBIDDEN'));
    }
    req.booking = booking;
    next();
  } catch (e) {
    next(e);
  }
}

module.exports = { bookingAccess };
