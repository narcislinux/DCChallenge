#!/bin/bash
AWS_ECR_LOGIN=$(aws ecr get-login-password --region $AWS_DEFAULT_REGION)
echo $AWS_ECR_LOGIN | docker login -u AWS --password-stdin $REPOSITORY_URI
docker pull $REPOSITORY_URI:latest
