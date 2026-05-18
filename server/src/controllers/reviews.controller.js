const reviewsService = require('../services/reviews.service');
const { AppError } = require('../middleware/errorHandler');

async function create(req, res, next) {
  try {
    const { rating, comment } = req.body;
    if (!rating || rating < 1 || rating > 5) {
      throw new AppError('Rating 1-5 required', 400, 'VALIDATION_ERROR');
    }
    const data = await reviewsService.create(req.user.id, req.params.bookingId, { rating, comment });
    res.status(201).json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function listByListing(req, res, next) {
  try {
    const data = await reviewsService.listByListing(req.params.listingId);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function listByProvider(req, res, next) {
  try {
    const data = await reviewsService.listByProvider(req.params.providerId);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

module.exports = { create, listByListing, listByProvider };
