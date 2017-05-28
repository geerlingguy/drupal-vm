#!/bin/bash
#
# Commit a Docker image and save it to an archive (tar).
#
# Required configuration (in config.yml):
#
#     docker_container_name: drupal-vm
#     docker_image_name: drupal-vm
#     docker_image_path: ~/Downloads
#

# Exit on any individual command failure.
set -e

# Include YAML parser.
source provisioning/docker/parse-yaml.sh

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

# Set variables, read from config.yml if available.
# TODO: This could definitely be more intelligent!
if [ -f 'config.yml' ]; then
  container_name=$(parse_yaml config.yml docker_container_name)
  image_name=$(parse_yaml config.yml docker_image_name)
  image_path=$(parse_yaml config.yml docker_image_path)
else
  container_name=$(parse_yaml default.config.yml docker_container_name)
  image_name=$(parse_yaml default.config.yml docker_image_name)
  image_path=$(parse_yaml default.config.yml docker_image_path)
fi

image_full_path="$image_path/$image_name.tar.gz"
image_full_path="${image_full_path/#\~/$HOME}" # Expand ~ to $HOME.

# Save the image.
printf "\n"${green}"Saving Docker container to $image_full_path..."${neutral}"\n"
docker commit $container_name $image_name
docker save $image_name | gzip -1 > $image_full_path
printf ${green}"...done!"${neutral}"\n"
