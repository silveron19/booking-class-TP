const express = require('express');
const {
  getAllRequestHandler,
  getRequestByQueryHandler,
  getRequestByIdHandler,
  getRequestByUserHandler,
  postRejectedRequestHandler,
  deleteRequestByIdHandler,
} = require('./Handler');
const approveRequest = require('../../middleware/ApproveRequestById');
const { putSessionByIdHandler } = require('../session/Handler');
const checkRoleMiddleware = require('../../middleware/CheckRoleHandler');
const validateToken = require('../../middleware/ValidateTokenHandler');

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
router.post(
  '/request/:id/tolak',
  checkRoleMiddleware,
  postRejectedRequestHandler
);
router.post(
  '/request/:id/terima',
  checkRoleMiddleware,
  approveRequest,
  putSessionByIdHandler
);
router.delete('/request/:requestId', deleteRequestByIdHandler);

module.exports = router;
