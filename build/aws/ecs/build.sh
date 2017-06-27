#!/usr/bin/env bash
env
VERSION="${bamboo_buildNumber}"

# Get the ECR login
eval $(aws ecr get-login)

# Build docker image based on Dockerfile in repo
docker build -f ../../Docker/Dockerfile.production -t contest:${VERSION} ../../../

# Tag the docker image with ${VERSION} tag
docker tag contest:${VERSION} 134856371062.dkr.ecr.eu-central-1.amazonaws.com/contest:${VERSION}

# Push the image to AWS ECS
docker push 134856371062.dkr.ecr.eu-central-1.amazonaws.com/contest:${VERSION}
