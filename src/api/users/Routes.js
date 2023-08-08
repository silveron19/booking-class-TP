// login router
const express = require('express');
const {
  loginUserHandler,
  currentUserHandler,
  getUserByIdHandler,
} = require('./Handler');

const router = express.Router();

router.post('/login', loginUserHandler);
router.get('/profile', getUserByIdHandler);
router.get('/current', currentUserHandler);

module.exports = router;
