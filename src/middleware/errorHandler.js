const { constants } = require('../../constants');
const logger = require('../../logger');

// eslint-disable-next-line no-unused-vars
const errorHandler = (err, req, res, next) => {
  const statusCode = err.status || 500;

  switch (statusCode) {
    case constants.VALIDATION_ERROR:
      logger.error(`Validation Failed: ${err.message}\n${err.stack}`);
      res.status(statusCode).json({
        title: 'Validation Failed',
        message: err.message,
      });
      break;

    case constants.NOT_FOUND:
      logger.error(`Not Found: ${err.message}\n${err.stack}`);
      res.status(statusCode).json({
        title: 'Not Found',
        message: err.message,
      });
      break;

    case constants.UNAUTHORIZED:
      logger.error(`Unauthorized: ${err.message}\n${err.stack}`);
      res.status(statusCode).json({
        title: 'Unauthorized',
        message: err.message,
      });
      break;

    case constants.FORBIDDEN:
      logger.error(`Forbidden: ${err.message}\n${err.stack}`);
      res.status(statusCode).json({
        title: 'Forbidden',
        message: err.message,
      });
      break;

    case constants.CONFLICT:
      logger.error(`Conflict Error: ${err.message}\n${err.stack}`);
      res.status(statusCode).json({
        title: 'Conflict Error',
        message: err.message,
      });
      break;

    default:
      logger.error(`Internal Server Error: ${err.message}\n${err.stack}`);
      res.status(500).json({
        title: 'Internal Server Error',
        message: 'Something went wrong.',
      });
      break;
  }
};

module.exports = errorHandler;
