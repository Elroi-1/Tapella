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

function validatePrice(priceEtb) {
  if (priceEtb === undefined || priceEtb === null) return undefined;
  const parsed = Number(priceEtb);
  if (!Number.isFinite(parsed) || parsed < 0) {
    throw new AppError('priceEtb must be a non-negative number', 400, 'VALIDATION_ERROR');
  }
  return parsed;
}

async function create(req, res, next) {
  try {
    const title = typeof req.body.title === 'string' ? req.body.title.trim() : '';
    const category = typeof req.body.category === 'string' ? req.body.category.trim() : '';
    if (!title || !category) {
      throw new AppError('Title and category required', 400, 'VALIDATION_ERROR');
    }
    const priceEtb = validatePrice(req.body.priceEtb);
    const data = await listingsService.create(req.user.id, {
      ...req.body,
      title,
      category,
      ...(priceEtb !== undefined ? { priceEtb } : {}),
    });
    res.status(201).json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

async function update(req, res, next) {
  try {
    const priceEtb = validatePrice(req.body.priceEtb);
    const data = await listingsService.update(req.params.id, {
      ...req.body,
      ...(priceEtb !== undefined ? { priceEtb } : {}),
    });
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
