const { Router } = require('express');
const authController = require('../controllers/auth.controller');
const { authenticateJwt } = require('../middleware/authenticateJwt');

const router = Router();

router.post('/register/customer', authController.registerCustomer);
router.post('/register/provider', authController.registerProvider);
router.post('/login/customer', authController.loginCustomer);
router.post('/login/provider', authController.loginProvider);
router.post('/refresh', authController.refresh);
router.get('/me', authenticateJwt, authController.me);
router.patch('/profile', authenticateJwt, authController.updateProfile);
router.delete('/account', authenticateJwt, authController.deleteAccount);

module.exports = router;
