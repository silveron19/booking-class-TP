const express = require('express');
const {
  getAllRequestHandler,
  getRequestByIdHandler,
  postRejectedRequestHandler,
} = require('./Handler');
const approveRequest = require('../../middleware/approveRequestById');
const { putSessionByIdHandler } = require('../session/Handler');
const checkRoleMiddleware = require('../../middleware/CheckRoleHandler');

const router = express.Router();

router.get('/request', checkRoleMiddleware, getAllRequestHandler);
router.get('/request/:id', checkRoleMiddleware, getRequestByIdHandler);
router.post('/request/:id/tolak', checkRoleMiddleware, postRejectedRequestHandler);
router.post('/request/:id', checkRoleMiddleware, approveRequest, putSessionByIdHandler);

module.exports = router;
