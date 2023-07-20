const asyncHandler = require('express-async-handler');
const jwt = require('jsonwebtoken');
const User = require('../models/userModel');

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

const loginUser = asyncHandler(async (req, res) => {
  const { name, password } = req.body;
  if (!name || !password) {
    res.status(400);
    throw new Error('All field are mandatory');
  }
  const user = await User.findOne({ name, password });
  if (user) {
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

const currentUser = asyncHandler(async (req, res) => {
  res.json(req.user);
});

module.exports = { loginUser, createUser, currentUser };
