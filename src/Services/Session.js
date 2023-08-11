const Session = require('../api/session/Model');
const Request = require('../api/request/Model');

async function getSessionsByDepartment(department) {
  const sessions = await Session.find({ department })
    .populate('subject', 'name')
    .exec();
  if (!sessions) {
    return null;
  }

  const result = sessions.map((session) => ({
    ...session.toObject(),
    participants: session.student.length,
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
    { new: true }
  )
    .populate('subject', 'name')
    .exec();
  if (!session) {
    return null;
  }

  const result = {
    ...session.toObject(),
    participants: session.student.length,
  };
  return result;
}

async function getSessionsByDate(userId, deviceDay) {
  const result = await Session.find({
    student: userId,
    day: deviceDay,
  })
    .populate('student', '-password')
    .populate({
      path: 'subject',
    })
    .populate({
      path: 'classroom',
    })
    .exec();

  if (!result) {
    return null;
  }
  return result;
}

async function getSessionsByUser(userId) {
  const result = await Session.find({ student: userId })
    .populate('student', '-password')

    .populate({
      path: 'subject',
    })
    .populate({
      path: 'classroom',
    })
    .exec();

  if (!result) {
    return null;
  }
  return result;
}

async function createRequestBySession(
  userId,
  sessionId,
  new_day,
  new_start_time,
  new_end_time,
  new_classroom,
  reason
) {
  const result = await Request.create({
    request_by: userId,
    session_detail: sessionId,
    new_day,
    new_start_time,
    new_end_time,
    new_classroom,
    reason,
  });

  if (!result) {
    return null;
  }
  return result;
}

module.exports = {
  getSessionsByDepartment,
  updateSessionById,
  getSessionsByDate,
  getSessionsByUser,
  createRequestBySession,
};
