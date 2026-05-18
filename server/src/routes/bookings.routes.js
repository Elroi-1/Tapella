const { Router } = require('express');
const bookingsController = require('../controllers/bookings.controller');
const { authenticateJwt } = require('../middleware/authenticateJwt');
const { requireRole } = require('../middleware/requireRole');

const router = Router();

router.post('/', authenticateJwt, requireRole('customer'), bookingsController.create);
router.get('/mine', authenticateJwt, requireRole('customer'), bookingsController.listMine);
router.get('/incoming', authenticateJwt, requireRole('provider'), bookingsController.listIncoming);
router.get('/history', authenticateJwt, requireRole('provider'), bookingsController.listHistory);
router.patch('/:id/status', authenticateJwt, requireRole('provider'), bookingsController.updateStatus);
router.patch('/:id/complete', authenticateJwt, requireRole('provider'), bookingsController.complete);
router.patch('/:id/cancel', authenticateJwt, requireRole('customer'), bookingsController.cancel);

module.exports = router;
