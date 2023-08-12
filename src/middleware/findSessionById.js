const { constants } = require('../../constants');
const Session = require('../api/session/Model');
const errorHandler = require('./errorHandler');

async function findSessionDetailById(req, res, next) {
  const { sessionId } = req.params;

  const session = await Session.findOne({ _id: sessionId })
    .populate({
      path: 'subject',
      select: 'name class_president',
      populate: { path: 'class_president', select: '_id name' },
    })
    .populate('student')
    .exec();
  if (!session) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Session not found',
    }, req, res);
    return;
  }

  const result = {
    // status: 'Success',
    ...session.toObject(),
    student_quantity: session.student.length,
  };
  req.session = result;
  next();
}

module.exports = findSessionDetailById;
