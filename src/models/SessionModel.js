const mongoose = require('mongoose');
const Subject = require('./SubjectModel');

const { Schema, model } = mongoose;

// schema model for REQUEST collection
const sessionSchema = new Schema({
  _id: { type: Schema.Types.ObjectId, required: true },
  day: { type: String, required: true },
  start_time: { type: String, required: true },
  end_time: { type: String, required: true },
  student: [{ type: String, required: true }],
  subject: { type: String, required: true, ref: 'SUBJECTS' },
  lecturer: { type: String, required: true },
  classroom: { type: String, required: true },
  department: { type: String, required: true }
}, { collection: 'SESSIONv2' });

const Session = model('SESSIONv2', sessionSchema);

module.exports = { Session, Subject };
