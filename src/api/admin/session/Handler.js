const asyncHandler = require('express-async-handler');
const { constants } = require('../../../../constants');
const getSessionsByDepartment = require('../../../Services/Session');
const errorHandler = require('../../../middleware/ErrorHandler');
const { updateClassPresident } = require('../../../Services/Subject');

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
  const { userId } = req.params;
  if (!session) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Subject not found',
    }, req, res);
  }
  const result = await updateClassPresident(session.subject, userId);

  res.status(200).send(result);
});

module.exports = {
  getAllSessionHandler,
  patchClassPresidentHandler,
  getSessionDetailHandler
};
