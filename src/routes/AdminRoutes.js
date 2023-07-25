// login router
const express = require('express');
const {
  getAllRequest,
  getSession
} = require('../controllers/AdminController');

const validateToken = require('../middleware/ValidateTokenHandler');
const errorHandler = require('../middleware/ErrorHandler');

const router = express.Router();

router.get('/request', validateToken, getAllRequest, errorHandler);
router.get('/schedule', validateToken, getSession);
router.get('/schedule/:name', validateToken, getSession);

module.exports = router;
