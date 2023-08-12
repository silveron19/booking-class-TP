const asyncHandler = require('express-async-handler');
const { constants } = require('../../../constants');
const errorHandler = require('../../middleware/errorHandler');
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
  const formattedCapacity = `CR${capacityNumber}`;
  const formattedFloor = floor.toLowerCase();

  const sessions = await getSessionByFilter(day, start_time, end_time);

  const classrooms = await getAllClassroom();

  const availableClass = classrooms
    .filter((classroom) => sessions
      .some((session) => session.classroom !== classroom._id));

  const emptyClass = await getEmptyClass(availableClass, formattedCapacity, formattedFloor);
  if (emptyClass.length === 0) {
    errorHandler({
      status: constants.NOT_FOUND,
      message: 'Class is full',
    }, req, res);
    return;
  }
  res.status(200).send(emptyClass);
});

module.exports = {
  getEmptyClassHandler,
};
