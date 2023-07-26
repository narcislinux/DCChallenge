#!/bin/bash
source /opt/DCChallenge/.env
DCC_ECR_LOGIN=$(aws ecr get-login-password --region $DCC_DEFAULT_REGION)
echo $DCC_ECR_LOGIN | docker login -u AWS --password-stdin $DCC_REPOSITORY_URI
docker pull $DCC_REPOSITORY_URI:latest
