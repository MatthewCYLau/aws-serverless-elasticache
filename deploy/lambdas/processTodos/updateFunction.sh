npm i && zip -r processTodos.zip index.js node_modules && \
aws s3 cp processTodos.zip \
    s3://aws-serverless-elasticache-lambdas/v1.0.0/processTodos.zip && \
aws lambda update-function-code \
    --function-name ProcessTodos \
    --s3-bucket aws-serverless-elasticache-lambdas \
    --s3-key v1.0.0/processTodos.zip