const Subject = require('../api/subject/Model');

async function getSubjectById(id) {
  const result = await Subject.findOne({ _id: id });
  if (!result) {
    return null;
  }
  return result;
}

async function updateClassPresident(id, classPresidentId) {
  const result = await Subject.findOneAndUpdate(
    { _id: id },
    { $set: { class_president: classPresidentId } },
    { new: true },
  );
  if (!result) {
    return null;
  }
  return result;
}

module.exports = { getSubjectById, updateClassPresident };
