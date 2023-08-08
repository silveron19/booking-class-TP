const mongoose = require('mongoose');

// Connect to mongoDB
const connectDb = async () => {
  try {
    mongoose.set('debug', false);
    const connect = await mongoose.connect(process.env.CONNECTION_STRING);
    console.log('Database connected: ', connect.connection.name);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
};

module.exports = connectDb;
