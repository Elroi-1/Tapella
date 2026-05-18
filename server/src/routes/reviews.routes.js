const { Router } = require('express');
const reviewsController = require('../controllers/reviews.controller');
const { authenticateJwt } = require('../middleware/authenticateJwt');
const { requireRole } = require('../middleware/requireRole');

const router = Router();

router.post('/bookings/:bookingId', authenticateJwt, requireRole('customer'), reviewsController.create);
router.get('/listings/:listingId', reviewsController.listByListing);
router.get('/providers/:providerId', reviewsController.listByProvider);

module.exports = router;
