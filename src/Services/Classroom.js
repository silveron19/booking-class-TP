const Classroom = require('../api/classroom/Model');

async function getEmptyClass(id, capacity, floor) {
  const result = await Classroom.find({ _id: id, capacity, floor }, { _id: 1 });

  return result;
}

async function getAllClassroom() {
  const result = await Classroom.find().select('_id');

  return result;
}
module.exports = { getEmptyClass, getAllClassroom };
