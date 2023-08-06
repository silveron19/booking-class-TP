const express = require('express');
const { getAllSessionHandler, patchClassPresidentHandler, getSessionDetailHandler } = require('./Handler');
const findSessionDetailById = require('../../../middleware/findSessionById');

const router = express.Router();

router.get('/schedule', getAllSessionHandler);
router.get('/schedule/:sessionId', findSessionDetailById, getSessionDetailHandler);
router.patch('/schedule/:sessionId/:userId', findSessionDetailById, patchClassPresidentHandler);

module.exports = router;
