#!/bin/bash
#
# Load a Docker image from an archive (tar).
#
# Required configuration (in config.yml):
#
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
  image_name=$(parse_yaml config.yml docker_image_name)
  image_path=$(parse_yaml config.yml docker_image_path)
else
  image_name=$(parse_yaml default.config.yml docker_image_name)
  image_path=$(parse_yaml default.config.yml docker_image_path)
fi

image_full_path="$image_path/$image_name.tar.gz"
image_full_path=${image_full_path/#\~/$HOME} # Expand ~ to $HOME.

# Load the image.
printf "\n"${green}"Loading Docker image..."${neutral}"\n"
gunzip -c $image_full_path | docker load
printf ${green}"...done!"${neutral}"\n"
