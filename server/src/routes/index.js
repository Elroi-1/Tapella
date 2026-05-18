const { Router } = require('express');
const authRoutes = require('./auth.routes');
const listingsRoutes = require('./listings.routes');
const bookingsRoutes = require('./bookings.routes');
const reviewsRoutes = require('./reviews.routes');

const router = Router();

router.get('/health', (_req, res) => {
  res.json({ success: true, data: { status: 'ok', timestamp: new Date().toISOString() } });
});

router.use('/auth', authRoutes);
router.use('/listings', listingsRoutes);
router.use('/bookings', bookingsRoutes);
router.use('/reviews', reviewsRoutes);

module.exports = router;
