const express = require('express');
const {
  getAllRequestHandler,
  getRequestByQueryHandler,
  getRequestByIdHandler,
  getRequestByUserHandler,
  putRequestHandler,
  deleteRequestByIdHandler,
} = require('./Handler');
const approveRequest = require('../../middleware/approveRequestById');
const { putSessionByIdHandler } = require('../session/Handler');
const checkRoleMiddleware = require('../../middleware/CheckRoleHandler');
const validateToken = require('../../middleware/validateTokenHandler');

const router = express.Router();

router.use(validateToken);

function checkRoleAndExecuteHandler(req, res) {
  const userRole = req.user.role;

  if (userRole === 'admin') {
    getAllRequestHandler(req, res);
  } else {
    getRequestByUserHandler(req, res);
  }
}

router.get('/request', checkRoleAndExecuteHandler);

router.get('/request?', getRequestByQueryHandler);

router.get('/request/:id', getRequestByIdHandler);

router.put(
  '/request/:id?',
  checkRoleMiddleware,
  putRequestHandler,
  approveRequest,
  putSessionByIdHandler,
);

router.delete('/request/:requestId', deleteRequestByIdHandler);

module.exports = router;
