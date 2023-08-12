const mongoose = require('mongoose');

// schema model for SUBJECTS collection
const classroomSchema = mongoose.Schema(
  {
    _id: {
      type: String,
      required: true,
    },
    floor: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      required: true,
    },
    capacity: {
      type: String,
      required: true,
    },
  },
  { collection: 'CLASSROOM' },
);

module.exports = mongoose.model('CLASSROOM', classroomSchema);
