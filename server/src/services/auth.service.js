const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { prisma } = require('../db/database');
const env = require('../config/env');
const { AppError } = require('../middleware/errorHandler');

function sanitizeUser(user) {
  if (!user) return null;
  return {
    id: user.id,
    email: user.email,
    role: user.role,
    displayName: user.displayName,
    phone: user.phone,
    location: user.location,
    bio: user.bio,
    profileImage: user.profileImage,
    profession: user.profession,
    createdAt: user.createdAt.toISOString(),
  };
}

function signTokens(user) {
  const payload = { sub: user.id, role: user.role, email: user.email };
  const accessToken = jwt.sign(payload, env.jwtSecret, { expiresIn: env.accessExpiresIn });
  const refreshToken = jwt.sign(payload, env.jwtRefreshSecret, { expiresIn: env.refreshExpiresIn });
  return { accessToken, refreshToken };
}

async function register({ email, password, displayName, role, phone, location, profession }) {
  const existing = await prisma.user.findUnique({
    where: { email: email.toLowerCase() }
  });
  
  if (existing) {
    throw new AppError('Email already registered', 409, 'EMAIL_EXISTS');
  }

  const passwordHash = await bcrypt.hash(password, 10);
  
  const user = await prisma.user.create({
    data: {
      email: email.toLowerCase(),
      passwordHash,
      role,
      displayName,
      phone: phone || null,
      location: location || null,
      profession: profession || null,
    }
  });

  const tokens = signTokens(user);
  return { ...tokens, user: sanitizeUser(user) };
}

async function login({ email, password, expectedRole }) {
  const user = await prisma.user.findUnique({
    where: { email: email.toLowerCase() }
  });

  if (!user) {
    throw new AppError('Invalid credentials', 401, 'INVALID_CREDENTIALS');
  }
  const valid = await bcrypt.compare(password, user.passwordHash);
  if (!valid) {
    throw new AppError('Invalid credentials', 401, 'INVALID_CREDENTIALS');
  }
  if (expectedRole && user.role !== expectedRole) {
    throw new AppError(`Please use ${user.role} login`, 403, 'WRONG_ROLE');
  }
  const tokens = signTokens(user);
  return { ...tokens, user: sanitizeUser(user) };
}

async function refresh(refreshToken) {
  try {
    const payload = jwt.verify(refreshToken, env.jwtRefreshSecret);
    const user = await prisma.user.findUnique({
      where: { id: payload.sub }
    });
    if (!user) throw new AppError('User not found', 404, 'NOT_FOUND');
    return signTokens(user);
  } catch {
    throw new AppError('Invalid refresh token', 401, 'INVALID_TOKEN');
  }
}

async function getMe(userId) {
  const user = await prisma.user.findUnique({
    where: { id: userId }
  });
  if (!user) throw new AppError('User not found', 404, 'NOT_FOUND');
  return sanitizeUser(user);
}

async function updateProfile(userId, body) {
  const user = await prisma.user.findUnique({
    where: { id: userId }
  });
  if (!user) throw new AppError('User not found', 404, 'NOT_FOUND');

  if (body.email && body.email.toLowerCase() !== user.email) {
    const taken = await prisma.user.findFirst({
      where: {
        email: body.email.toLowerCase(),
        id: { not: userId }
      }
    });
    if (taken) throw new AppError('Email already in use', 409, 'EMAIL_EXISTS');
  }

  const updatedUser = await prisma.user.update({
    where: { id: userId },
    data: {
      displayName: body.displayName ?? user.displayName,
      email: (body.email ?? user.email).toLowerCase(),
      phone: body.phone ?? user.phone,
      location: body.location ?? user.location,
      bio: body.bio ?? user.bio,
      profileImage: body.profileImage !== undefined ? body.profileImage : user.profileImage,
      profession: body.profession !== undefined ? body.profession : user.profession,
    }
  });
  
  return sanitizeUser(updatedUser);
}

async function deleteAccount(userId) {
  const user = await prisma.user.findUnique({
    where: { id: userId }
  });
  if (!user) throw new AppError('User not found', 404, 'NOT_FOUND');

  await prisma.$transaction([
    prisma.review.deleteMany({
      where: { OR: [{ customerId: userId }, { providerId: userId }] }
    }),
    prisma.booking.deleteMany({
      where: { OR: [{ customerId: userId }, { providerId: userId }] }
    }),
    prisma.listing.updateMany({
      where: { providerId: userId },
      data: { deletedAt: new Date() }
    }),
    prisma.user.delete({
      where: { id: userId }
    })
  ]);
  
  return { deleted: true };
}

module.exports = { register, login, refresh, getMe, updateProfile, deleteAccount, sanitizeUser };
