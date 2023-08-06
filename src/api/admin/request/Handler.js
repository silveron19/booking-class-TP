const asyncHandler = require('express-async-handler');
const { constants } = require('../../../../constants');
const getClassPresidentByDepartment = require('../../../Services/ClassPresident');
const { getRequestsById, getRequestDetailById, postRequestWhyById } = require('../../../Services/Request');
const errorHandler = require('../../../middleware/ErrorHandler');

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

const postRequestWhyHandler = asyncHandler(async (req, res) => {
  const { why } = req.body;
  const { id } = req.params;

  const request = await postRequestWhyById(id, why);
  if (!request) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Request not found',
    }, req, res);
    return;
  }
  res.status(200).send(request);
});

module.exports = { getRequestByIdHandler, getAllRequestHandler, postRequestWhyHandler };
