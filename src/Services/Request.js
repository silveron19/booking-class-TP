const Request = require('../api/request/Model');
const Session = require('../api/session/Model');
const Subject = require('../api/subject/Model');

async function getRequestsById(id, sort) {
  let sortCriteria = {};

  if (sort.toLowerCase() === 'terbaru') {
    sortCriteria = { created_at: -1 };
  } else if (sort.toLowerCase() === 'terlama') {
    sortCriteria = { created_at: 1 };
  }

  const result = await Request.find({
    request_by: id,
    status: 'Menunggu Verifikasi',
  }).sort(sortCriteria)
    .populate('request_by', 'name')
    .populate({
      path: 'session_detail',
      select: 'subject',
      populate: { path: 'subject', select: 'name' },
    })
    .exec();

  return result;
}

async function getRequestsByQuery(id, status, sort) {
  const query = { request_by: id }; // Kueri dasar (default)

  if (status.toLowerCase() !== 'semua') {
    query.status = { $regex: status, $options: 'i' };
  }

  let sortCriteria = {};

  if (sort.toLowerCase() === 'terbaru') {
    sortCriteria = { created_at: -1 };
  } else if (sort.toLowerCase() === 'terlama') {
    sortCriteria = { created_at: 1 };
  }

  const result = await Request.find(query)
    .sort(sortCriteria)
    .populate('request_by')
    .populate({
      path: 'session_detail',
      model: Session,
      populate: {
        path: 'subject',
        model: Subject,
      },
    })
    .exec();

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

  return result;
}

async function deleteRequestById(requestId) {
  const result = await Request.findByIdAndDelete(requestId);

  return result;
}

module.exports = {
  getRequestsById,
  getRequestsByQuery,
  getRequestDetailById,
  rejectRequest,
  deleteRequestById,
};
