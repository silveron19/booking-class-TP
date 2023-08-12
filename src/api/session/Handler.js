const asyncHandler = require('express-async-handler');
const { constants } = require('../../../constants');
const {
  getSessionsByDepartment,
  updateSessionById,
  getSessionsByDate,
  getSessionsByUser,
  createRequestBySession,
} = require('../../services/Session');
const errorHandler = require('../../middleware/errorHandler');
const { updateClassPresident } = require('../../services/Subject');

function getNamaHari(angkaHari) {
  const namaHari = [
    'Minggu',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];
  return namaHari[angkaHari];
}

const getTodaySessionsHandler = asyncHandler(async (req, res) => {
  const userId = req.user._id;
  const device = new Date();
  const deviceDayIndex = device.getDay(); // Mendapatkan angka hari dalam pekan
  const deviceDay = getNamaHari(deviceDayIndex);

  const sessions = await getSessionsByDate(userId, deviceDay);
  if (!sessions) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Subject not found',
      },
      req,
      res,
    );
  }
  res.status(200).send(sessions);
});

const getSessionsHandler = asyncHandler(async (req, res) => {
  const userId = req.user._id;

  const sessions = await getSessionsByUser(userId);
  if (!sessions) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Subject not found',
      },
      req,
      res,
    );
  }
  res.status(200).send(sessions);
});

const postRequestByUserHandler = asyncHandler(async (req, res) => {
  const userId = req.user._id;
  const { sessionId } = req.params;
  const {
    new_day, new_start_time, new_end_time, new_classroom, reason,
  } = req.body;

  const sessions = await createRequestBySession(
    userId,
    sessionId,
    new_day,
    new_start_time,
    new_end_time,
    new_classroom,
    reason,
  );
  if (!sessions) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Subject not found',
      },
      req,
      res,
    );
  }
  res.status(200).send(sessions);
});

const getAllSessionHandler = asyncHandler(async (req, res) => {
  const { department } = req.user;

  const sessions = await getSessionsByDepartment(department);
  if (!sessions) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Subject not found',
      },
      req,
      res,
    );
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
  const id = session.subject;

  if (!session) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Subject not found',
      },
      req,
      res,
    );
  }
  const result = await updateClassPresident(id, userId);

  res.status(200).send(result);
});

const putSessionByIdHandler = asyncHandler(async (req, res) => {
  const { request } = req;

  const result = await updateSessionById(request);
  if (!result) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'Subject not found',
      },
      req,
      res,
    );
    return;
  }
  res.status(200).send(result);
});

module.exports = {
  getAllSessionHandler,
  patchClassPresidentHandler,
  getSessionDetailHandler,
  putSessionByIdHandler,
  getTodaySessionsHandler,
  getSessionsHandler,
  postRequestByUserHandler,
};
