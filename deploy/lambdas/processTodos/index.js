const serverless = require("serverless-http");
const bodyParser = require("body-parser");
const express = require("express");
const redis = require("redis");
const { promisify } = require("util");
const app = express();

app.use(bodyParser.json({ strict: false }));

const redisConfig = {
  // To-do: update host URL
  host: "test.kskdyd.0001.use1.cache.amazonaws.com",
  port: 6379
};

app.get("/ping", function(req, res) {
  res.send("pong!");
});

app.get("/set", function(req, res) {
  const client = redis.createClient(redisConfig);
  client.on("ready", () => {
    console.log(client.ping());
  });
  client.set("foo", "bar");
  res.send("Set!");
});

app.get("/get", async function(req, res) {
  console.log("Getting...");
  const client = redis.createClient(redisConfig);
  client.on("ready", () => {
    console.log(client.ping());
  });
  const getAsync = promisify(client.get).bind(client);
  const val = await getAsync("foo");
  res.send(val);
});

app.get("/todos", function(req, res) {
  res.send("Get todos");
});

app.post("/todos", function(req, res) {
  res.send("Create todos");
});

module.exports.handler = serverless(app);
