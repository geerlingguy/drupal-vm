#!/bin/bash
#
# Bake a Docker container with Drupal VM.

# Exit on any individual command failure.
set -e

# Set variables.
DRUPALVM_MACHINE_NAME="${DRUPALVM_MACHINE_NAME:-drupal-vm}"
DRUPALVM_HOSTNAME="${DRUPALVM_HOSTNAME:-localhost}"
DRUPALVM_PROJECT_ROOT="${DRUPALVM_PROJECT_ROOT:-/var/www/drupalvm}"

HOST_HTTP_PORT="${HOST_HTTP_PORT:-8080}"
HOST_HTTPS_PORT="${HOST_HTTPS_PORT:-8443}"

DISTRO="${DISTRO:-ubuntu1604}"
OPTS="${OPTS:---privileged}"
INIT="${INIT:-/lib/systemd/systemd}"

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

# Set volume options.
if [[ "$OSTYPE" == "darwin"* ]]; then
  volume_opts='rw,cached'
else
  volume_opts='rw'
fi

# Run the container.
printf "\n"${green}"Bringing up Docker container..."${neutral}"\n"
docker run --name=$DRUPALVM_MACHINE_NAME -d \
  --add-host "$DRUPALVM_HOSTNAME  drupalvm":127.0.0.1 \
  -v $PWD:$DRUPALVM_PROJECT_ROOT/:$volume_opts \
  -p $HOST_HTTP_PORT:80 \
  -p $HOST_HTTPS_PORT:443 \
  $OPTS \
  geerlingguy/docker-$DISTRO-ansible:latest \
  $INIT

# Create Drupal directory.
docker exec $DRUPALVM_MACHINE_NAME mkdir -p $DRUPALVM_PROJECT_ROOT/drupal

# Set things up and run the Ansible playbook.
printf "\n"${green}"Running setup playbook..."${neutral}"\n"
docker exec --tty $DRUPALVM_MACHINE_NAME env TERM=xterm \
  ansible-playbook $DRUPALVM_PROJECT_ROOT/tests/test-setup.yml

printf "\n"${green}"Provisioning Drupal VM inside Docker container..."${neutral}"\n"
docker exec $DRUPALVM_MACHINE_NAME env TERM=xterm ANSIBLE_FORCE_COLOR=true \
  ansible-playbook $DRUPALVM_PROJECT_ROOT/provisioning/playbook.yml

printf "\n"${green}"...done!"${neutral}"\n"

printf "\n"${green}"Visit the Drupal VM dashboard: http://localhost:$HOST_HTTP_PORT"${neutral}"\n"
