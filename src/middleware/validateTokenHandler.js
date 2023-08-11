// package for handling exceptions inside of async to express error handler
const jwt = require('jsonwebtoken');

// validating jwt access token
async function validateToken(req, res, next) {
  // check the header with the name 'authorization'
  const authHeader = req.headers.authorization;
  // the authreader will be split and the array [1] will be taken
  const token = authHeader.split(' ')[1];
  // will verify the access token when the authHeader starts with 'bearer'
  if (authHeader && authHeader.startsWith('Bearer')) {
    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, decoded) => {
      if (err) {
        res.status(401);
        throw new Error('User is not authorized');
      }
      // decoded user contained in access token
      req.user = decoded.user;
      next();
    });

    if (!token) {
      res.status(401);
      throw new Error('User is not authorized or token is missing');
    }
  }
}

module.exports = validateToken;
