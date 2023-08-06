const express = require('express');
const {
  getAllRequestHandler,
  getRequestByIdHandler,
  postRequestWhyHandler
} = require('./Handler');

const router = express.Router();

router.get('/request', getAllRequestHandler,);
router.get('/request/:id', getRequestByIdHandler);
router.post('/request/:id/tolak', postRequestWhyHandler);

module.exports = router;
