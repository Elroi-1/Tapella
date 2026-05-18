const { Router } = require('express');
const listingsController = require('../controllers/listings.controller');
const { authenticateJwt, optionalAuth } = require('../middleware/authenticateJwt');
const { requireRole } = require('../middleware/requireRole');
const { listingOwnership } = require('../middleware/listingOwnership');

const router = Router();

router.get('/', optionalAuth, listingsController.list);
router.get('/mine', authenticateJwt, requireRole('provider'), listingsController.listMine);
router.get('/:id', optionalAuth, listingsController.getOne);
router.post('/', authenticateJwt, requireRole('provider'), listingsController.create);
router.patch('/:id', authenticateJwt, requireRole('provider'), listingOwnership, listingsController.update);
router.delete('/:id', authenticateJwt, requireRole('provider'), listingOwnership, listingsController.remove);

module.exports = router;
