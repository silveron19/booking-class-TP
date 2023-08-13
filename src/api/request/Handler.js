const asyncHandler = require('express-async-handler');
const {
  getRequestsById,
  getRequestDetailById,
  rejectRequest,
  getRequestsByQuery,
  deleteRequestById,
} = require('../../services/Request');
const { constants } = require('../../../constants');
const errorHandler = require('../../middleware/errorHandler');

const getAllRequestHandler = asyncHandler(async (req, res) => {
  const { classPresidentId } = req;
  const { sort } = req.query;

  const requests = await getRequestsById(classPresidentId, sort);
  if (requests.length === 0) {
    errorHandler(
      {
        status: constants.NO_CONTENT,
        message: 'The server has processed the request, but no content was found',
      },
      req,
      res,
    );
    return;
  }
  res.status(200).send(requests);
});

const getRequestByUserHandler = asyncHandler(async (req, res) => {
  const id = req.user._id;
  const requests = await getRequestsById(id);
  if (requests.length === 0) {
    errorHandler(
      {
        status: constants.NO_CONTENT,
        message: 'The server has processed the request, but no content was found',
      },
      req,
      res,
    );
    return;
  }
  res.status(200).send(requests);
});

const getRequestByQueryHandler = asyncHandler(async (req, res) => {
  const { status, sort } = req.query;
  const id = req.user._id;
  const requests = await getRequestsByQuery(id, status, sort);
  if (requests.length === 0) {
    errorHandler(
      {
        status: constants.NO_CONTENT,
        message: 'The server has processed the request, but no content was found',
      },
      req,
      res,
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
      res,
    );
    return;
  }

  res.status(200).send(request);
});

const putRequestHandler = asyncHandler(async (req, res, next) => {
  const { id } = req.params;
  const { choose } = req.query;

  const request = await getRequestDetailById(id);
  if (!request) {
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

  if (request.status !== 'Menunggu Verifikasi') {
    errorHandler(
      {
        status: constants.CONFLICT,
        message: 'Unable to accept / reject request that has been previously approved / rejected',
      },
      req,
      res,
    );
    return;
  }
  if (choose.toLowerCase() === 'terima') {
    next();
  } else if (choose.toLowerCase() === 'tolak') {
    const { why } = req.body;
    if (!why) {
      errorHandler(
        {
          status: constants.CONFLICT,
          message: 'Unable to reject the request. The reason field is required',
        },
        req,
        res,
      );
      return;
    }

    const result = await rejectRequest(request._id, why);
    res.status(200).send(result);
  }
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
      res,
    );
    return;
  }
  res.status(200).send({ deleted: request });
});

module.exports = {
  getRequestByIdHandler,
  getAllRequestHandler,
  putRequestHandler,
  getRequestByUserHandler,
  getRequestByQueryHandler,
  deleteRequestByIdHandler,
};
