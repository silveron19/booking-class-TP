const express = require('express');
const connectDb = require('./config/dbConnection');
const requestRoutes = require('./api/admin/request/Routes');
const sessionRoutes = require('./api/admin/session/Routes');
const userRoutes = require('./api/users/Routes');
const checkRoleMiddleware = require('./middleware/CheckRoleHandler');
const validateToken = require('./middleware/ValidateTokenHandler');
require('dotenv').config();

const app = express();
const port = process.env.PORT;
const host = process.env.HOST;

connectDb();

// app.use(cors());
app.use(express.json());
// app.use(bodyParser.json());

app.use('/api', userRoutes);
app.use('/api/admin', validateToken, checkRoleMiddleware, [requestRoutes, sessionRoutes]);

app.listen(port, () => console.log(`MRuangan listening on http://${host}:${port}`));
