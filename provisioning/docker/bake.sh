#!/bin/bash
#
# Bake a Docker container with Drupal VM.

# Exit on any individual command failure.
set -e

# Set variables.
DRUPALVM_IP_ADDRESS="${DRUPALVM_IP_ADDRESS:-192.168.89.89}"
DRUPALVM_MACHINE_NAME="${DRUPALVM_MACHINE_NAME:-drupal-vm}"
DRUPALVM_HOSTNAME="${DRUPALVM_HOSTNAME:-localhost}"
DRUPALVM_PROJECT_ROOT="${DRUPALVM_PROJECT_ROOT:-/var/www/drupalvm}"

DRUPALVM_HTTP_PORT="${DRUPALVM_HTTP_PORT:-80}"
DRUPALVM_HTTPS_PORT="${DRUPALVM_HTTPS_PORT:-443}"

DISTRO="${DISTRO:-ubuntu1604}"
OPTS="${OPTS:---privileged}"
INIT="${INIT:-/lib/systemd/systemd}"

# Helper function to colorize statuses.
function status() {
  status=$1
  printf "\n"
  echo -e -n "\033[32m$status"
  echo -e '\033[0m'
}

# Set volume options.
if [[ "$OSTYPE" == "darwin"* ]]; then
  volume_opts='rw,cached'
else
  volume_opts='rw'
fi

# Run the container.
status "Bringing up Docker container..."
docker run --name=$DRUPALVM_MACHINE_NAME -d \
  --add-host "$DRUPALVM_HOSTNAME  drupalvm":127.0.0.1 \
  -v $PWD:$DRUPALVM_PROJECT_ROOT/:$volume_opts \
  -p $DRUPALVM_IP_ADDRESS:$DRUPALVM_HTTP_PORT:80 \
  -p $DRUPALVM_IP_ADDRESS:$DRUPALVM_HTTPS_PORT:443 \
  $OPTS \
  geerlingguy/docker-$DISTRO-ansible:latest \
  $INIT

# Create Drupal directory.
docker exec $DRUPALVM_MACHINE_NAME mkdir -p $DRUPALVM_PROJECT_ROOT/drupal

# Set things up and run the Ansible playbook.
status "Running setup playbook..."
docker exec --tty $DRUPALVM_MACHINE_NAME env TERM=xterm \
  ansible-playbook $DRUPALVM_PROJECT_ROOT/tests/test-setup.yml

status "Provisioning Drupal VM inside Docker container..."
docker exec $DRUPALVM_MACHINE_NAME env TERM=xterm ANSIBLE_FORCE_COLOR=true \
  ansible-playbook $DRUPALVM_PROJECT_ROOT/provisioning/playbook.yml

status "...done!"
status "Visit the Drupal VM dashboard: http://$DRUPALVM_IP_ADDRESS:$DRUPALVM_HTTP_PORT"
