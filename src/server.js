const express = require('express');
const connectDb = require('./config/dbConnection');
require('dotenv').config();

const app = express();
const port = process.env.PORT;

connectDb();

app.use(express.json());
// the main path of the users route
app.use('/api/users', require('./routes/userRoutes'));
// app.use('/api/schedule', require('./routes/sessionRoutes'));

app.listen(port, () => console.log(`MRuangan listening on port ${port}!`));
