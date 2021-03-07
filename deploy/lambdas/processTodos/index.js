const serverless = require("serverless-http");
const bodyParser = require("body-parser");
const express = require("express");
const redis = require("redis");
const app = express();

app.use(bodyParser.json({ strict: false }));

const redisConfig = {
  // To-do: update host URL
  host: "app-redis.kskdyd.ng.0001.use1.cache.amazonaws.com",
  port: 6379
};

app.get("/ping", function(req, res) {
  res.send("pong!");
});

app.get("/set", function(req, res) {
  const client = redis.createClient(redisConfig);
  client.set("key", "value");
  res.send("Set!");
});

app.get("/get", function(req, res) {
  const client = redis.createClient(redisConfig);
  client.get("key", async (err, data) => {
    if (err) {
      res.send("Error");
    }
    if (data) {
      res.send("Yes cache!");
    } else {
      res.send("No cache");
    }
  });
});

app.get("/todos", function(req, res) {
  res.send("Get todos");
});

app.post("/todos", function(req, res) {
  res.send("Create todos");
});

module.exports.handler = serverless(app);
