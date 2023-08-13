const express = require('express');
const {
  getAllSessionHandler,
  patchClassPresidentHandler,
  getSessionDetailHandler,
  getTodaySessionsHandler,
  postRequestByUserHandler,
} = require('./Handler');
const findSessionDetailById = require('../../middleware/findSessionById');
const { checkRoleMiddleware } = require('../../middleware/CheckRole');
const validateToken = require('../../middleware/validateTokenHandler');

const router = express.Router();

router.use(validateToken);

router.get('/schedule', getAllSessionHandler);

router.post('/schedule/:sessionId', postRequestByUserHandler);

router.get(
  '/schedule/:sessionId',
  findSessionDetailById,
  getSessionDetailHandler,
);
router.patch(
  '/schedule/:sessionId',
  checkRoleMiddleware,
  findSessionDetailById,
  patchClassPresidentHandler,
);
router.get('/home', getTodaySessionsHandler);

module.exports = router;
