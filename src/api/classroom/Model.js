const mongoose = require('mongoose');

const { Schema, model } = mongoose;
// schema model for REQUEST collection
const classroomSchema = new Schema({
  _id: { type: String, required: true },
  floor: { type: String, required: true },
  status: { type: String, required: true },
  capacity: { type: String, required: true },
}, { collection: 'CLASSROOM' });

const Classroom = model('CLASSROOM', classroomSchema);

module.exports = Classroom;
