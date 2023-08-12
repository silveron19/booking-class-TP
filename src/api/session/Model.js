const mongoose = require('mongoose');
require('../subject/Model');
require('../users/Model');
require('../classroom/Model');

const { Schema, model } = mongoose;

// schema model for REQUEST collection
const sessionSchema = new Schema(
  {
    _id: { type: Schema.Types.ObjectId, required: true },
    day: { type: String, required: true },
    start_time: { type: String, required: true },
    end_time: { type: String, required: true },
    student: [{ type: String, required: true, ref: 'USERS' }],
    subject: { type: String, required: true, ref: 'SUBJECTS' },
    lecturer: { type: String, required: true },
    classroom: { type: String, required: true, ref: 'CLASSROOM' },
    department: { type: String, required: true },
  },
  { collection: 'SESSION' },
);

const Session = model('SESSION', sessionSchema);

module.exports = Session;
