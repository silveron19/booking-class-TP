// package for handling exceptions inside of async to express error handler
const asyncHandler = require('express-async-handler');
const jwt = require('jsonwebtoken');
const User = require('../models/userModel');

// just for test creating new data to database
const createUser = asyncHandler(async (req, res) => {
  const { name, password, department, semester, role } = req.body;
  const user = await User.create({
    name,
    password,
    department,
    semester,
    role,
  });

  res.status(201).json(user);
});

// TODO add refresh token authentication

// login API with jwt access token authentication
const loginUser = asyncHandler(async (req, res) => {
  // name & password is parameter to get user
  const { name, password } = req.body;
  if (!name || !password) {
    res.status(400);
    throw new Error('All field are mandatory');
  }
  // find one user that have name and password according to parameter
  const user = await User.findOne({ name, password });
  if (user) {
    // make jwt access token that contain user information and ACCESS_TOKEN_SECRET
    const accessToken = jwt.sign(
      {
        user: {
          _id: user._id,
          name: user.name,
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
const currentUser = asyncHandler(async (req, res) => {
  res.json(req.user);
});

module.exports = { loginUser, createUser, currentUser };
