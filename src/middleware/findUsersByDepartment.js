const { constants } = require('../../constants');
const { getAllUserByDepartment } = require('../services/Users');
const errorHandler = require('./errorHandler');

const findUserIdsMiddleware = async (req, res, next) => {
  const users = await getAllUserByDepartment(req.department);
  if (!users) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Session not found',
    }, req, res);
    return;
  }
  const userId = users.map((user) => user._id);
  req.userId = userId;
  next();
};

module.exports = findUserIdsMiddleware;
