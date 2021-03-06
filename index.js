const serverless = require("serverless-http");
const express = require("express");
const app = express();

app.get("/ping", function(req, res) {
  res.send("pong!");
});

module.exports.handler = serverless(app);
