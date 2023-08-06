const Session = require('../api/admin/session/Model');
const errorHandler = require('./ErrorHandler');

async function findSessionDetailById(req, res, next) {
  const { sessionId } = req.params;

  const session = await Session.findOne({ _id: sessionId })
    .populate('subject', 'name class_president')
    .populate('student')
    .exec();
  if (!session) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Request not found',
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
