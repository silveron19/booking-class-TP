const { getAllSubjectById } = require('../services/Subject');

const findClassPresidentIdsMiddleware = async (req, res, next) => {
  const subjects = await getAllSubjectById(req.userId);
  const classPresidentId = subjects
    .map((user) => user.class_president)
    .filter((value, index, self) => self.indexOf(value) === index);

  if (!subjects) {
    return null;
  }
  req.classPresidentId = classPresidentId;
  return next();
};

module.exports = findClassPresidentIdsMiddleware;
