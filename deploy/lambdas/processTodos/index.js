const serverless = require("serverless-http");
const bodyParser = require("body-parser");
const express = require("express");
const redis = require("redis");
const AWS = require("aws-sdk");
const { promisify } = require("util");
const app = express();

app.use(bodyParser.json({ strict: false }));

const redisConfig = {
  host: process.env.REDIS_HOST_URL,
  port: 6379
};

const dynamoDb = new AWS.DynamoDB.DocumentClient();

app.get("/ping", function(req, res) {
  res.send("pong!");
});

app.get("/v1/todos", function(req, res) {
  const params = {
    TableName: "todos"
  };

  dynamoDb.scan(params, (error, result) => {
    if (error) {
      res.status(404).json({ error: `Error when fetching todos: ${error}` });
    } else {
      res.status(200).json(result.Items);
    }
  });
});

app.get("/v1/todos/:todoId", async function(req, res) {
  const params = {
    TableName: "todos",
    Key: {
      todoId: req.params.todoId
    }
  };

  dynamoDb.get(params, (error, result) => {
    if (error) {
      res.status(404).json({ error: `Error when fetching todo: ${error}` });
    }
    if (result.Item) {
      const { todoId, todo } = result.Item;
      res.json({ todoId, todo });
    } else {
      res.status(404).json({ error: "Todo not found" });
    }
  });
});

// Sets/gets data from ElastiCache Redis
app.get("/v2/todos/:todoId", async function(req, res) {
  const params = {
    TableName: "todos",
    Key: {
      todoId: req.params.todoId
    }
  };

  const client = redis.createClient(redisConfig);
  const getAsync = promisify(client.get).bind(client);
  const val = await getAsync(req.params.todoId);
  client.quit();

  if (val) {
    const { todoId, todo } = JSON.parse(val);
    res.json({ todoId, todo });
  } else {
    dynamoDb.get(params, (error, result) => {
      if (error) {
        res.status(404).json({ error: `Error when fetching todo: ${error}` });
      }
      if (result.Item) {
        const client = redis.createClient(redisConfig);
        client.set(req.params.todoId, JSON.stringify(result.Item));
        client.quit();
        const { todoId, todo } = result.Item;
        res.json({ todoId, todo });
      } else {
        res.status(404).json({ error: "Todo not found" });
      }
    });
  }
});

app.post("/todos", function(req, res) {
  const params = {
    TableName: "todos",
    Item: {
      todoId: req.requestContext.requestId,
      todo: req.body.todo
    }
  };

  dynamoDb.put(params, error => {
    if (error) {
      res.status(404).json({ error: `Error when creating todo: ${error}` });
    } else {
      res
        .status(200)
        .json({ todoId: req.requestContext.requestId, todo: req.body.todo });
    }
  });
});

module.exports.handler = serverless(app);
