const winston = require('winston');
const DailyRotateFile = require('winston-daily-rotate-file');
const path = require('path');
const fs = require('fs');
const winstonMongoDB = require('winston-mongodb');

const logDirectory = path.join(__dirname, 'logs');
require('dotenv').config();

if (!fs.existsSync(logDirectory)) {
  fs.mkdirSync(logDirectory);
}

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new DailyRotateFile({
      filename: path.join(logDirectory, '%DATE%-app.log'),
      datePattern: 'YYYY-MM-DD',
      zippedArchive: true,
      maxSize: '20m',
      maxFiles: '14d',
    }),
    new winston.transports.Console({}),
    new winstonMongoDB.MongoDB({
      db: process.env.CONNECTION_STRING,
      options: {
        useUnifiedTopology: true,
      },
      collection: 'LOGS',
    }),
  ],
});

module.exports = logger;
