const mongoose = require('mongoose');
require('../session/Model');
require('../users/Model');

const { Schema, model } = mongoose;
// schema model for REQUEST collection
const requestSchema = new Schema(
  {
    request_by: { type: String, required: true, ref: 'USERS' },
    new_day: { type: String, required: true },
    new_start_time: { type: String, required: true },
    new_end_time: { type: String, required: true },
    new_classroom: { type: String, required: true },
    session_detail: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: 'SESSION',
    },
    reason: { type: String, required: true },
    status: { type: String, default: 'Menunggu Verifikasi' },
    created_at: { type: Date, required: false },
    updated_at: { type: Date, required: false, default: null },
    why: { type: String, required: false },
  },
  {
    collection: 'REQUEST',
    timestamps: {
      createdAt: 'created_at', // Use `created_at` to store the created date
      updatedAt: 'updated_at', // and `updated_at` to store the last updated date
    },
    versionKey: false,
  },
);

const Request = model('REQUEST', requestSchema);

module.exports = Request;
