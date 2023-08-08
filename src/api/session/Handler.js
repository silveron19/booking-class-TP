const asyncHandler = require('express-async-handler');
const { constants } = require('../../../constants');
const { getSessionsByDepartment, updateSessionById } = require('../../services/Session');
const errorHandler = require('../../middleware/ErrorHandler');
const { updateClassPresident } = require('../../services/Subject');

//* YOUR REQUEST, ADHI
const getAllSessionHandler = asyncHandler(async (req, res) => {
  const { department } = req.user;

  const sessions = await getSessionsByDepartment(department);
  if (!sessions) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Subject not found',
    }, req, res);
  }
  res.status(200).send(sessions);
});

const getSessionDetailHandler = asyncHandler(async (req, res) => {
  const { session } = req;
  res.status(200).send(session);
});

const patchClassPresidentHandler = asyncHandler(async (req, res) => {
  const { session } = req;
  const { userId } = req.query;
  if (!session) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Subject not found',
    }, req, res);
  }
  const result = await updateClassPresident(session.subject, userId);

  res.status(200).send(result);
});

const putSessionByIdHandler = asyncHandler(async (req, res) => {
  const { request } = req;

  const result = await updateSessionById(request);
  if (!result) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Subject not found',
    }, req, res);
    return;
  }
  res.status(200).send(result);
});

module.exports = {
  getAllSessionHandler,
  patchClassPresidentHandler,
  getSessionDetailHandler,
  putSessionByIdHandler,
};
