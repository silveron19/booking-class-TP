const mongoose = require('mongoose');
require('../users/Model');

const { Schema, model } = mongoose;

const subjectSchema = new Schema({
  _id: { type: String, required: true },
  name: { type: String, required: true },
  class_president: { type: String, required: true, ref: 'USERS' },
}, { collection: 'SUBJECTS' });

const Subject = model('SUBJECTS', subjectSchema);

module.exports = Subject;
