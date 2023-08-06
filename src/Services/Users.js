const Users = require('../api/users/Model');

async function getUserById(id) {
  const projection = { _id: 0, password: 0, role: 0 };
  const user = await Users.findOne({ _id: id }, projection);
  if (!user) {
    return null;
  }
  return user;
}

module.exports = getUserById;
