const { constants } = require('../../constants');
const Request = require('../api/request/Model');
const errorHandler = require('./errorHandler');

async function approveRequest(req, res, next) {
  const { id } = req.params;

  const result = await Request.findOneAndUpdate(
    { _id: id },
    { $set: { status: 'Diterima', updated_at: new Date() } },
    { new: true },
  )
    .populate('request_by', 'name')
    .populate({
      path: 'session_detail',
      populate: { path: 'subject', select: 'name' },
    })
    .exec();

  if (!result) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Request not found',
      },
      req,
      res,
    );
    return;
  }
  req.request = result;
  next();
}

module.exports = approveRequest;
