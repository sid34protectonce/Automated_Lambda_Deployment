module.exports.function1 = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: "Hello from function1!",
        input: event,
      },
      null,
      2
    ),
  };
};

module.exports.function2 = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: "Hello from function2!",
        input: event,
      },
      null,
      2
    ),
  };
};