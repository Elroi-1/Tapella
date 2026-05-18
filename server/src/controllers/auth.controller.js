const authService = require('../services/auth.service');
const { AppError } = require('../middleware/errorHandler');

function validateAuthBody(body, requireName = false) {
  if (!body.email || !body.password) {
    throw new AppError('Email and password required', 400, 'VALIDATION_ERROR');
  }
  if (requireName && !body.displayName) {
    throw new AppError('Display name required', 400, 'VALIDATION_ERROR');
  }
}

async function registerCustomer(req, res, next) {
  try {
    validateAuthBody(req.body, true);
    const result = await authService.register({
      email: req.body.email,
      password: req.body.password,
      displayName: req.body.displayName,
      role: 'customer',
      phone: req.body.phone,
    });
    res.status(201).json({ success: true, data: result });
  } catch (e) {
    next(e);
  }
}

async function registerProvider(req, res, next) {
  try {
    validateAuthBody(req.body, true);
    const result = await authService.register({
      email: req.body.email,
      password: req.body.password,
      displayName: req.body.displayName,
      role: 'provider',
      phone: req.body.phone,
      profession: req.body.profession,
    });
    res.status(201).json({ success: true, data: result });
  } catch (e) {
    next(e);
  }
}

async function loginCustomer(req, res, next) {
  try {
    validateAuthBody(req.body);
    const result = await authService.login({
      email: req.body.email,
      password: req.body.password,
      expectedRole: 'customer',
    });
    res.json({ success: true, data: result });
  } catch (e) {
    next(e);
  }
}

async function loginProvider(req, res, next) {
  try {
    validateAuthBody(req.body);
    const result = await authService.login({
      email: req.body.email,
      password: req.body.password,
      expectedRole: 'provider',
    });
    res.json({ success: true, data: result });
  } catch (e) {
    next(e);
  }
}

async function refresh(req, res, next) {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) throw new AppError('Refresh token required', 400, 'VALIDATION_ERROR');
    const result = await authService.refresh(refreshToken);
    res.json({ success: true, data: result });
  } catch (e) {
    next(e);
  }
}

async function me(req, res, next) {
  try {
    const user = await authService.getMe(req.user.id);
    res.json({ success: true, data: user });
  } catch (e) {
    next(e);
  }
}

async function updateProfile(req, res, next) {
  try {
    const user = await authService.updateProfile(req.user.id, req.body);
    res.json({ success: true, data: user });
  } catch (e) {
    next(e);
  }
}

async function deleteAccount(req, res, next) {
  try {
    const data = await authService.deleteAccount(req.user.id);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

module.exports = {
  registerCustomer,
  registerProvider,
  loginCustomer,
  loginProvider,
  refresh,
  me,
  updateProfile,
  deleteAccount,
};
