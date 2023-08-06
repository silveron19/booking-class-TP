const checkRoleMiddleware = (req, res, next) => {
  if (!req.user.role) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  if (req.user.role === 'admin') {
    return next();
  }

  return res.status(403).json({ message: 'Access denied' });
};

module.exports = checkRoleMiddleware;
