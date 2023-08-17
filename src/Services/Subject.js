const Subject = require('../api/subject/Model');

async function getSubjectById(id) {
  const result = await Subject.findOne({ _id: id });

  return result;
}

async function updateClassPresident(id, classPresidentId) {
  const result = await Subject.findOneAndUpdate(
    { _id: id },
    { $set: { class_president: classPresidentId } },
    { new: true },
  );

  return result;
}

async function getAllSubjectById(userId) {
  const result = await Subject.find({ class_president: userId });

  return result;
}

module.exports = { getSubjectById, updateClassPresident, getAllSubjectById };
