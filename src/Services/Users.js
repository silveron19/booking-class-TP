const jwt = require('jsonwebtoken');
const Users = require('../api/users/Model');

// login API with jwt access token authentication
async function createJWT(user) {
  // make jwt access token that contain user information and ACCESS_TOKEN_SECRET
  const accessToken = jwt.sign(
    {
      user: {
        _id: user._id,
        name: user.name,
        department: user.department,
        role: user.role,
      },
    },
    process.env.ACCESS_TOKEN_SECRET,
  );
  return accessToken;
}

async function getUserById(id) {
  const projection = { _id: 0, password: 0, role: 0 };
  const user = await Users.findOne({ _id: id }, projection);
  if (!user) {
    return null;
  }
  return user;
}

module.exports = { getUserById, createJWT };
