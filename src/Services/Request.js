const Request = require('../api/request/Model');

async function getRequestsById(id) {
  const result = await Request.find({
    request_by: id,
    status: 'Menunggu Verifikasi',
  })
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

async function getRequestsByQuery(status, sort) {
  const query = { request_by: req.user._id }; // Kueri dasar (default)

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
    { new: true }
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

async function deleteRequestById(requestId) {
  const result = await Request.findByIdAndDelete(requestId);

  if (!result) {
    return null;
  }

  return result;
}

module.exports = {
  getRequestsById,
  getRequestsByQuery,
  getRequestDetailById,
  rejectRequest,
  deleteRequestById,
};
