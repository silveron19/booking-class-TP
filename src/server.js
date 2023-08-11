const express = require('express');
const connectDb = require('./config/dbConnection');
const requestRoutes = require('./api/request/Routes');
const sessionRoutes = require('./api/session/Routes');
const userRoutes = require('./api/users/Routes');
const classroomRoutes = require('./api/classroom/Routes');
const validateToken = require('./middleware/ValidateTokenHandler');

require('dotenv').config();

const app = express();
const port = process.env.PORT;
const host = process.env.HOST;

connectDb();

// app.use(cors());
app.use(express.json());
// app.use(bodyParser.json());
app.use('/api', userRoutes, [requestRoutes, sessionRoutes, classroomRoutes]);

app.listen(port, () => console.log(`MRuangan listening on http://${host}:${port}`));
