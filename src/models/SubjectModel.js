const mongoose = require('mongoose');

const { Schema, model } = mongoose;

// schema model for REQUEST collection
const subjectSchema = new Schema({
  _id: { type: String, required: true },
  name: { type: String, required: true },
  class_president: { type: String, required: true }
}, { collection: 'SUBJECTS' });

const Subject = model('SUBJECTS', subjectSchema);

module.exports = Subject;
