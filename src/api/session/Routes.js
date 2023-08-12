const express = require('express');
const {
  getAllSessionHandler,
  patchClassPresidentHandler,
  getSessionDetailHandler,
  getTodaySessionsHandler,
  getSessionsHandler,
  postRequestByUserHandler,
} = require('./Handler');
const findSessionDetailById = require('../../middleware/findSessionById');
const checkRoleMiddleware = require('../../middleware/CheckRoleHandler');
const validateToken = require('../../middleware/validateTokenHandler');

const router = express.Router();

router.use(validateToken);

function checkRoleAndExecuteHandler(req, res) {
  const userRole = req.user.role;

  if (userRole === 'admin') {
    getAllSessionHandler(req, res);
  } else {
    getSessionsHandler(req, res);
  }
}

router.get('/schedule', checkRoleAndExecuteHandler);

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
