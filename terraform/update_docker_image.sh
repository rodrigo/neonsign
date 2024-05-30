#!/bin/bash
set -e
image_tag=$(git rev-parse --short HEAD)
image=525726440883.dkr.ecr.us-east-1.amazonaws.com/neonsign:${image_tag}
if [ -z "$(docker images -q ${image} 2> /dev/null)" ]; then
  docker build -t 525726440883.dkr.ecr.us-east-1.amazonaws.com/neonsign:${image_tag} .. > deploy_docker_image.log
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 525726440883.dkr.ecr.us-east-1.amazonaws.com > deploy_docker_image.log
  docker push ${image} > deploy_docker_image.log
fi

printf "{\"image_tag\":\"$(git rev-parse --short HEAD)\"}"
