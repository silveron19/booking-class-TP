const express = require('express');
const { getEmptyClassHandler } = require('./Handler');

const router = express.Router();

router.get('/classroom', getEmptyClassHandler);

module.exports = router;
