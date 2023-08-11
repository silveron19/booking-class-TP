const asyncHandler = require('express-async-handler');
const {
  getRequestsById,
  getRequestDetailById,
  rejectRequest,
  getRequestsByQuery,
  deleteRequestById,
} = require('../../Services/Request');
const { constants } = require('../../../constants');
const errorHandler = require('../../middleware/ErrorHandler');
const { getAllUserByDepartment } = require('../../Services/Users');
const { getAllSubjectById } = require('../../Services/Subject');

const getAllRequestHandler = asyncHandler(async (req, res) => {
  const { department } = req.user;

  const users = await getAllUserByDepartment(department);
  const userId = users.map((user) => user._id);
  const subjects = await getAllSubjectById(userId);
  const classPresidentId = subjects.map((user) => user.class_president);
  const requests = await getRequestsById(classPresidentId);
  if (!requests) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Request not found',
      },
      req,
      res
    );
    return;
  }
  res.status(200).send(requests);
});

const getRequestByUserHandler = asyncHandler(async (req, res) => {
  const id = req.user._id;
  const requests = await getRequestsById(id);
  if (!requests) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Request not found',
      },
      req,
      res
    );
    return;
  }
  res.status(200).send(requests);
});

const getRequestByQueryHandler = asyncHandler(async (req, res) => {
  const { status, sort } = req.query;
  const requests = await getRequestsByQuery(status, sort);
  if (!requests) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Request not found',
      },
      req,
      res
    );
    return;
  }
  res.status(200).send(requests);
});

const getRequestByIdHandler = asyncHandler(async (req, res) => {
  const { id } = req.params;

  const request = await getRequestDetailById(id);
  if (!request) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Request not found',
      },
      req,
      res
    );
    return;
  }

  res.status(200).send(request);
});

const postRejectedRequestHandler = asyncHandler(async (req, res) => {
  const { why } = req.body;
  const { id } = req.params;

  const request = await rejectRequest(id, why);
  if (!request) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Request not found',
      },
      req,
      res
    );
    return;
  }
  res.status(200).send(request);
});

const deleteRequestByIdHandler = asyncHandler(async (req, res) => {
  const { requestId } = req.params;

  const request = await deleteRequestById(requestId);
  if (!request) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Request not found',
      },
      req,
      res
    );
    return;
  }
  res.status(200).send({ deleted: request });
});

module.exports = {
  getRequestByIdHandler,
  getAllRequestHandler,
  postRejectedRequestHandler,
  getRequestByUserHandler,
  getRequestByQueryHandler,
  deleteRequestByIdHandler,
};
