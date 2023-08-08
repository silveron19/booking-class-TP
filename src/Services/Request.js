const Request = require('../api/request/Model');

async function getRequestsById(id) {
  const result = await Request.find({ request_by: id })
    .populate('request_by', 'name')
    .populate({
      path: 'session_detail',
      select: 'subject',
      populate: { path: 'subject', select: 'name' },
    })
    .exec();

  if (!result) {
    return null;
  }
  return result;
}

async function getRequestDetailById(id) {
  const result = await Request.findOne({ _id: id })
    .populate('request_by', 'name')
    .populate({
      path: 'session_detail',
      populate: { path: 'subject', select: 'name' },
    })
    .exec();

  if (!result) {
    return null;
  }
  return result;
}

async function rejectRequest(id, why) {
  const result = await Request.findOneAndUpdate(
    { _id: id },
    { $set: { why, status: 'Ditolak', updated_at: new Date() } },
    { new: true },
  )
    .populate('request_by', 'name')
    .populate({
      path: 'session_detail',
      populate: { path: 'subject', select: 'name' },
    })
    .exec();

  if (!result) {
    return null;
  }

  return result;
}

module.exports = {
  getRequestsById,
  getRequestDetailById,
  rejectRequest,
};
