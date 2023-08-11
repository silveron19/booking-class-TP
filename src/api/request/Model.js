const mongoose = require('mongoose');
require('../session/Model');
require('../users/Model');

const { Schema, model } = mongoose;
// schema model for REQUEST collection
const requestSchema = new Schema({
  _id: { type: Schema.Types.ObjectId, required: true },
  request_by: { type: String, required: true, ref: 'USERS' },
  new_day: { type: String, required: true },
  new_start_time: { type: String, required: true },
  new_end_time: { type: String, required: true },
  new_classroom: { type: String, required: true },
  session_detail: { type: Schema.Types.ObjectId, required: true, ref: 'SESSION' },
  reason: { type: String, required: true },
  status: { type: String, required: true },
  created_at: { type: Date, required: true },
  updated_at: { type: Date, required: true, default: null },
  why: { type: String },
}, { collection: 'REQUEST' });

const Request = model('REQUEST', requestSchema);

module.exports = Request;
