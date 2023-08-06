const mongoose = require('mongoose');

// schema model for USERS collection
const userSchema = mongoose.Schema(
  {
    _id: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: [true, 'Please add the name'],
    },
    password: {
      type: String,
      required: [true, 'Please add the user password'],
    },
    department: {
      type: String,
      required: [true, 'Please add the user department'],
    },
    semester: {
      type: Number,
      required: [true, 'Please add the user semester'],
    },
    role: {
      type: String,
      required: [true, 'Please add the user role'],
    },
    profile_pic: {
      type: String,
      default: null,
    },
  },
  { collection: 'USERS' }
);

module.exports = mongoose.model('USERS', userSchema);
