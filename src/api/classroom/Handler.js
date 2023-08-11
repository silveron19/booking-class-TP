const asyncHandler = require('express-async-handler');
const { constants } = require('../../../constants');
const errorHandler = require('../../middleware/ErrorHandler');
const { getEmptyClass, getAllClassroom } = require('../../services/Classroom');
const { getSessionByFilter } = require('../../services/Session');

const getEmptyClassHandler = asyncHandler(async (req, res) => {
  const {
    day,
    duration,
    floor,
    capacity,
  } = req.query;

  const [start_time, end_time] = duration.split('-');

  const capacityNumber = capacity.slice(10);
  console.log(capacityNumber);
  const formattedCapacity = `CR${capacityNumber}`;

  const formattedFloor = floor.toLowerCase();
  const sessions = await getSessionByFilter(day, start_time, end_time);
  const classrooms = await getAllClassroom();
  const availableClass = classrooms
    .filter((classroom) => sessions
      .some((session) => session.classroom !== classroom._id));
  const emptyClass = await getEmptyClass(availableClass, formattedCapacity, formattedFloor);
  console.log(formattedCapacity);
  if (!emptyClass) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Subject not found',
    }, req, res);
    return;
  }
  res.status(200).send(emptyClass);
});

module.exports = {
  getEmptyClassHandler,
};
