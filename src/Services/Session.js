const Session = require('../api/admin/session/Model');

async function getSessionsByDepartment(department) {
  const sessions = await Session.find({ department })
    .populate('subject', 'name')
    .exec();
  if (!sessions) {
    return null;
  }

  const result = sessions.map((session) => ({
    ...session.toObject(),
    student: session.student.length,
  }));
  return result;
}
module.exports = getSessionsByDepartment;
