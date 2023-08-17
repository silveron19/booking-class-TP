const { constants } = require('../../constants');
const { getAllSubjectById } = require('../services/Subject');
const errorHandler = require('./errorHandler');

const findClassPresidentIdsMiddleware = async (req, res, next) => {
  const subjects = await getAllSubjectById(req.userId);
  if (!subjects) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Subjects not found',
      },
      req,
      res,
    );
    return;
  }

  const classPresidentId = subjects
    .map((user) => user.class_president)
    .filter((value, index, self) => self.indexOf(value) === index);

  req.classPresidentId = classPresidentId;
  next();
};

module.exports = findClassPresidentIdsMiddleware;
