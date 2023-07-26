#!/bin/bash
source /opt/DCChallenge/.env
DDC_ECR_LOGIN=$(aws ecr get-login-password --region $DDC_DEFAULT_REGION)
echo $DDC_ECR_LOGIN | docker login -u AWS --password-stdin $DDC_REPOSITORY_URI
docker pull $DDC_REPOSITORY_URI:latest
