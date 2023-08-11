// package for handling exceptions inside of async to express error handler
const asyncHandler = require('express-async-handler');
const jwt = require('jsonwebtoken');
const Users = require('./Model');
const { constants } = require('../../../constants');
const errorHandler = require('../../middleware/ErrorHandler');
const { getUserById } = require('../../Services/Users');
// TODO add refresh token authentication

// login API with jwt access token authentication
const loginUserHandler = asyncHandler(async (req, res) => {
  // name & password is parameter to get user
  const { _id, password } = req.body;
  if (!_id || !password || Object.keys(req.body).length !== 2) {
    res.status(400);
    throw new Error('All field are mandatory');
  }
  // find one user that have name and password according to parameter
  const user = await Users.findOne({ _id, password });
  if (user) {
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
      process.env.ACCESS_TOKEN_SECRET
    );
    res.status(200).json({ accessToken });
  } else {
    res.status(404);
    throw new Error('User not found');
  }
});

// get current user information from jwt access token
const currentUserHandler = asyncHandler(async (req, res) => {
  const { user } = req;
  res.json(user);
});

const getUserByIdHandler = asyncHandler(async (req, res) => {
  const id = req.user._id;

  const result = await getUserById(id);
  if (!result) {
    errorHandler(
      {
        status: constants.NOT_FOUND,
        message: 'User not found',
      },
      req,
      res
    );
  }
  res.status(200).send(result);
});

module.exports = { loginUserHandler, currentUserHandler, getUserByIdHandler };
