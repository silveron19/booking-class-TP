// login router
const express = require('express');
const {
  loginUserHandler,
  currentUserHandler,
  getUserByIdHandler,
} = require('./Handler');

const validateToken = require('../../middleware/ValidateTokenHandler');

const router = express.Router();

router.post('/login', loginUserHandler);
router.get('/profile', validateToken, getUserByIdHandler);
router.get('/current', validateToken, currentUserHandler);

module.exports = router;
