const mongoose = require('mongoose');

const { Schema, model } = mongoose;

// schema model for USERS collection
const userSchema = Schema({
  _id: { type: String, required: true },
  name: { type: String, required: [true, 'Please add the name'] },
  password: { type: String, required: [true, 'Please add the user password'] },
  department: { type: String, required: [true, 'Please add the user department'] },
  semester: { type: Number, required: [true, 'Please add the user semester'] },
  role: { type: String, required: [true, 'Please add the user role'] },
  profile_pic: { type: String, default: null },
}, { collection: 'USERS' });

const Users = model('USERS', userSchema);
module.exports = Users;
