const Classroom = require('../api/classroom/Model');

async function getEmptyClass(id, capacity, floor) {
  const result = await Classroom.find({ _id: id, capacity, floor }, { _id: 1 });

  if (!result) {
    return null;
  }
  return result;
}

async function getAllClassroom() {
  const result = await Classroom.find().select('_id');

  if (!result) {
    return null;
  }
  return result;
}
module.exports = { getEmptyClass, getAllClassroom };
