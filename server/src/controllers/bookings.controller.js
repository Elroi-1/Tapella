const bookingsService = require('../services/bookings.service');
const { AppError } = require('../middleware/errorHandler');

async function create(req, res, next) {
  try {
    if (!req.body.listingId) throw new AppError('listingId required', 400, 'VALIDATION_ERROR');
    const data = await bookingsService.create(req.user.id, req.body);
    res.status(201).json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function listMine(req, res, next) {
  try {
    const data = await bookingsService.listCustomer(req.user.id);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function listIncoming(req, res, next) {
  try {
    const data = await bookingsService.listIncoming(req.user.id);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function listHistory(req, res, next) {
  try {
    const data = await bookingsService.listHistory(req.user.id);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function updateStatus(req, res, next) {
  try {
    const { status } = req.body;
    if (!['accepted', 'rejected'].includes(status)) {
      throw new AppError('status must be accepted or rejected', 400, 'VALIDATION_ERROR');
    }
    const data = await bookingsService.updateStatus(req.params.id, req.user.id, status);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function complete(req, res, next) {
  try {
    const { amountEtb } = req.body;
    const data = await bookingsService.complete(req.params.id, req.user.id, amountEtb);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function cancel(req, res, next) {
  try {
    const data = await bookingsService.cancelByCustomer(req.params.id, req.user.id);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

module.exports = { create, listMine, listIncoming, listHistory, updateStatus, complete, cancel };
