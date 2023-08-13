const express = require('express');
const {
  getAllRequestHandler,
  getRequestByIdHandler,
  putRequestHandler,
  deleteRequestByIdHandler,
} = require('./Handler');
const approveRequest = require('../../middleware/approveRequestById');
const { putSessionByIdHandler } = require('../session/Handler');
const {
  checkRoleMiddleware,
  checkRoleRequestMiddleware,
} = require('../../middleware/CheckRole');
const validateToken = require('../../middleware/validateTokenHandler');
const findUserIdsMiddleware = require('../../middleware/findUsersByDepartment');
const findClassPresidentIdsMiddleware = require('../../middleware/findClassPresidentId');

const router = express.Router();

router.use(validateToken);

router.get(
  '/request?',
  checkRoleRequestMiddleware,
  findUserIdsMiddleware,
  findClassPresidentIdsMiddleware,
  getAllRequestHandler,
);

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
