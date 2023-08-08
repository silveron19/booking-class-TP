const Session = require('../api/session/Model');

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

async function updateSessionById(request) {
  const update = {
    $set: {
      day: request.new_day,
      start_time: request.new_start_time,
      end_time: request.new_end_time,
      classroom: request.new_classroom,
    },
  };

  const session = await Session.findOneAndUpdate(
    { _id: request.session_detail },
    update,
    { new: true },
  )
    .populate('subject', 'name')
    .exec();
  if (!session) {
    return null;
  }

  const result = {
    ...session.toObject(),
    student: session.student.length,
  };
  return result;
}

module.exports = { getSessionsByDepartment, updateSessionById };
