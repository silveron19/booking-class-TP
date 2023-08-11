const express = require('express');
const {
  getAllSessionHandler,
  patchClassPresidentHandler,
  getSessionDetailHandler,
  getTodaySessions,
  getSessions,
  postRequestByUserHandler,
} = require('./Handler');
const findSessionDetailById = require('../../middleware/FindSessionById');
const checkRoleMiddleware = require('../../middleware/CheckRoleHandler');
const validateToken = require('../../middleware/ValidateTokenHandler');

const router = express.Router();

router.use(validateToken);

function checkRoleAndExecuteHandler(req, res) {
  const userRole = req.user.role;

  if (userRole === 'admin') {
    getAllSessionHandler(req, res);
  } else {
    getSessions(req, res);
  }
}

router.get('/schedule', checkRoleAndExecuteHandler);

router.post('/schedule/:sessionId', postRequestByUserHandler);

router.get(
  '/schedule/:sessionId',
  findSessionDetailById,
  getSessionDetailHandler
);
router.patch(
  '/schedule/:sessionId',
  checkRoleMiddleware,
  findSessionDetailById,
  patchClassPresidentHandler
);
router.get('/home', getTodaySessions);

module.exports = router;
