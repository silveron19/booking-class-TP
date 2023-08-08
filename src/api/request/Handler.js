const asyncHandler = require('express-async-handler');
const { getRequestsById, getRequestDetailById, rejectRequest } = require('../../services/Request');
const { constants } = require('../../../constants');
const errorHandler = require('../../middleware/ErrorHandler');
const getClassPresidentByDepartment = require('../../services/ClassPresident');

const getAllRequestHandler = asyncHandler(async (req, res) => {
  const { department } = req.user;

  const classPresident = await getClassPresidentByDepartment(department);
  const classPresidentId = classPresident.map((user) => user._id);

  const requests = await getRequestsById(classPresidentId);
  if (!requests) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Request not found',
    }, req, res);
    return;
  }
  res.status(200).send(requests);
});

const getRequestByIdHandler = asyncHandler(async (req, res) => {
  const { id } = req.params;

  const request = await getRequestDetailById(id);
  if (!request) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Request not found',
    }, req, res);
    return;
  }

  res.status(200).send(request);
});

const postRejectedRequestHandler = asyncHandler(async (req, res) => {
  const { why } = req.body;
  const { id } = req.params;

  const request = await rejectRequest(id, why);
  if (!request) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Request not found',
    }, req, res);
    return;
  }
  res.status(200).send(request);
});

module.exports = {
  getRequestByIdHandler,
  getAllRequestHandler,
  postRejectedRequestHandler,
};
