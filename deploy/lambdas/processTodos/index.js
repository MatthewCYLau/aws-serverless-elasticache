const serverless = require("serverless-http");
const bodyParser = require("body-parser");
const express = require("express");
const redis = require("redis");
const { promisify } = require("util");
const app = express();

app.use(bodyParser.json({ strict: false }));

const redisConfig = {
  // To-do: update host URL
  host: process.env.REDIS_HOST_URL,
  port: 6379
};

app.get("/ping", function(req, res) {
  res.send("pong!");
});

app.get("/set", function(req, res) {
  const client = redis.createClient(redisConfig);
  client.set("foo", "bar");
  client.quit();
  res.send("Set!");
});

app.get("/get", async function(req, res) {
  const client = redis.createClient(redisConfig);
  const getAsync = promisify(client.get).bind(client);
  const val = await getAsync("foo");
  client.quit();
  res.send(val);
});

app.get("/todos", function(req, res) {
  res.send("Get todos");
});

app.post("/todos", function(req, res) {
  res.send("Create todos");
});

module.exports.handler = serverless(app);
