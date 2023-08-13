const asyncHandler = require('express-async-handler');
const { getRequestByQueryHandler } = require('../api/request/Handler');

const checkRoleMiddleware = (req, res, next) => {
  if (!req.user.role) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  if (req.user.role === 'admin') {
    return next();
  }

  return res.status(403).json({ message: 'Access denied' });
};

const checkRoleRequestMiddleware = asyncHandler((req, res, next) => {
  if (!req.user.role) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  if (req.user.role === 'admin') {
    return next();
  }

  return getRequestByQueryHandler(req, res);
});

module.exports = { checkRoleMiddleware, checkRoleRequestMiddleware };
