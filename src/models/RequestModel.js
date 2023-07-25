const mongoose = require('mongoose');
const Session = require('./SessionModel');

const { Schema, model } = mongoose;
// schema model for REQUEST collection
const requestSchema = new Schema({
  _id: { type: Schema.Types.ObjectId, required: true },
  reqBy: { type: String, required: true },
  day: { type: String, required: true },
  createdAt: { type: String, required: true },
  updatedAt: { type: String, required: true, default: null },
  session: { type: String, required: true, ref: 'SESSIONv2' },
  reason: { type: String, required: true },
  status: { type: String, required: true }
}, { collection: 'REQUEST' });

const Request = model('REQUEST', requestSchema);

module.exports = { Request, Session };
