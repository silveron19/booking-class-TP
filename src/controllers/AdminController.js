const asyncHandler = require('express-async-handler');
// const mongoose = require('mongoose'); //* Jika ingin menggunakan double query
const { Request } = require('../models/RequestModel');
const User = require('../models/UserModel');
const { constants } = require('../../constants');
const { Session } = require('../models/SessionModel');

const getAllRequest = asyncHandler(async (req, res) => {
  const adminDepartment = req.user.department;

  const classPresident = await User.find({ role: 'ketua kelas', department: adminDepartment });
  const classPresidentId = classPresident.map((user) => user._id);
  const requests = await Request.findOne({ reqBy: classPresidentId[0] }).populate('session').exec();
  if (!requests) {
    throw constants.NOT_FOUND;
  }
  res.status(200).send(requests);
});

//* YOUR REQUEST, ADHI
const getSession = asyncHandler(async (req, res) => {
  const id = req.body._id;
  const { name } = req.params;
  const adminDepartment = req.user.department;

  if (id) {
    const session = await Session.findById(id).populate('subject').exec();
    if (session) {
      res.status(200).send({ session, name });
    }
  } else {
    const sessions = await Session.find({ department: adminDepartment });
    if (sessions) {
      res.status(200).send(sessions);
    }
    throw constants.NOT_FOUND;
  }
});

module.exports = { getAllRequest, getSession };

//* Jika ingin menggunakan double query pada getAllRequest
// const idSession = new mongoose.Types.ObjectId(requests.session);
// const sessionDetails = await Session.findById(idSession);
// if (!sessionDetails) {
//   throw constants.NOT_FOUND;
// }
// const result = {
//   _id: requests._id,
//   day: reqeusts.day, //dst...
//   session: sessionDetails
// };

// res.status(200).send(result);
