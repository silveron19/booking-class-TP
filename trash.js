// const getAllSession = asyncHandler(async (req, res) => {
//   const adminDepartment = req.user.department;

//   const sessions = await Session.find({ department: adminDepartment });
//   if (!sessions) {
//     throw constants.NOT_FOUND;
//   }
//   res.status(200).send(sessions);
// });

// const getSessionById = asyncHandler(async (req, res) => {
//   const id = req.body._id;
//   const { name } = req.params;

//   const session = await Session.findById(id).populate('subject').exec();

//   console.log(session);
//   if (!session) {
//     throw constants.NOT_FOUND;
//   }

//   res.status(200).send({ session, name });
// });

// const patchClassPresidentHandler = asyncHandler(async (req, res) => {
//   const { sessionId, userId } = req.body;

//   const session = await getSessionDetailById(sessionId, userId);
//   if (!session) {
//     errorHandler({
//       status: constants.NOT_FOUND,
//       message: 'Subject not found',
//     }, req, res);
//     return;
//   }
//   const result = await editClassPresident(session.subject);
//   res.status(200).send(result);
// });
