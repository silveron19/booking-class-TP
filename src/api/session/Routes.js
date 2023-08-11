const express = require('express');
const { getAllSessionHandler, patchClassPresidentHandler, getSessionDetailHandler } = require('./Handler');
const findSessionDetailById = require('../../middleware/findSessionById');
const checkRoleMiddleware = require('../../middleware/CheckRoleHandler');

const router = express.Router();

router.get('/schedule', checkRoleMiddleware, getAllSessionHandler);
router.get('/schedule/:sessionId', checkRoleMiddleware, findSessionDetailById, getSessionDetailHandler);
// router.get('/schedule/:sessionId', checkRoleMiddleware, getSessionDetailHandler);
router.patch('/schedule/:sessionId', checkRoleMiddleware, findSessionDetailById, patchClassPresidentHandler);
// router.patch('/schedule/:sessionId', checkRoleMiddleware, patchClassPresidentHandler);

module.exports = router;
