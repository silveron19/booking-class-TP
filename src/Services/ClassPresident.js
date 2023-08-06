const Users = require('../api/users/Model');

async function getClassPresidentByDepartment(department) {
  const result = await Users.find({ role: 'ketua kelas', department });
  if (!result) {
    return null;
  }
  return result;
}
module.exports = getClassPresidentByDepartment;
