const { getAllUserByDepartment } = require('../services/Users');

const findUserIdsMiddleware = async (req, res, next) => {
  const users = await getAllUserByDepartment(req.department);
  if (!users) {
    return null;
  }
  const userId = users.map((user) => user._id);
  req.userId = userId;
  return next();
};

module.exports = findUserIdsMiddleware;
