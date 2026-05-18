const listingsService = require('../services/listings.service');
const { AppError } = require('../middleware/errorHandler');

async function list(req, res, next) {
  try {
    const data = await listingsService.listPublic({
      search: req.query.search,
      category: req.query.category,
    });
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function getOne(req, res, next) {
  try {
    const data = await listingsService.getById(req.params.id);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function listMine(req, res, next) {
  try {
    const data = await listingsService.listMine(req.user.id);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function create(req, res, next) {
  try {
    if (!req.body.title || !req.body.category) {
      throw new AppError('Title and category required', 400, 'VALIDATION_ERROR');
    }
    const data = await listingsService.create(req.user.id, req.body);
    res.status(201).json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function update(req, res, next) {
  try {
    const data = await listingsService.update(req.params.id, req.body);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function remove(req, res, next) {
  try {
    const data = await listingsService.remove(req.params.id);
    res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

module.exports = { list, getOne, listMine, create, update, remove };
