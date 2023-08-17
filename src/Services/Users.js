const Users = require('../api/users/Model');

async function getUserById(id) {
  const projection = { _id: 0, password: 0, role: 0 };
  const user = await Users.findOne({ _id: id }, projection);

  return user;
}

async function getAllUserByDepartment(department) {
  const projection = { password: 0, role: 0 };
  const users = await Users.find({ department }, projection);

  return users;
}

module.exports = { getUserById, getAllUserByDepartment };
