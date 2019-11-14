#!/bin/bash
#
# A script to run Drupal VM functional tests.

# Set defaults if they're not set upstream.
CONFIG="${CONFIG:-tests/config.yml}"
MAKEFILE="${MAKEFILE:-example.drupal.make.yml}"
COMPOSERFILE="${COMPOSERFILE:-example.drupal.composer.json}"
HOSTNAME="${HOSTNAME:-drupalvm.test}"
MACHINE_NAME="${MACHINE_NAME:-drupalvm}"
IP="${IP:-192.168.88.88}"
DRUPALVM_DIR="${DRUPALVM_DIR:-/var/www/drupalvm}"
DRUSH_BIN="${DRUSH_BIN:-drush}"
TEST_INSTALLED_EXTRAS="${TEST_INSTALLED_EXTRAS:-true}"
CONTAINER_ID="${CONTAINER_ID:-dvm-test}"
type="${type:-tests/defaults}"
distro="${distro:-ubuntu1604}"
cleanup="${cleanup:-true}"

## Set up vars for Docker setup.
# CentOS 7
if [ $distro = 'centos7' ]; then
  init="/usr/lib/systemd/systemd"
  opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
# CentOS 8
elif [ $distro = 'centos8' ]; then
  init="/usr/lib/systemd/systemd"
  opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
# CentOS 6
elif [ $distro = 'centos6' ]; then
  init="/sbin/init"
  opts="--privileged"
# Ubuntu 18.04
elif [ $distro = 'ubuntu1804' ]; then
  init="/lib/systemd/systemd"
  opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
# Ubuntu 16.04
elif [ $distro = 'ubuntu1604' ]; then
  init="/lib/systemd/systemd"
  opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
# Debian 10
elif [ $distro = 'debian10' ]; then
  init="/lib/systemd/systemd"
  opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
# Debian 9
elif [ $distro = 'debian9' ]; then
  init="/lib/systemd/systemd"
  opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
fi

# Set OS-specific options.
if [[ "$OSTYPE" == "darwin"* ]]; then
  volume_opts='rw,cached'
else
  volume_opts='rw'
fi

# Use correct xargs command depending if it's GNU or BSD.
if xargs --version 2>&1 | grep -s GNU >/dev/null; then
  xargs_command='xargs -r'
else
  xargs_command='xargs'
fi

# Exit on any individual command failure.
set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

# Remove test container if it already exists.
printf "\n"${green}"Removing any existing test containers..."${neutral}"\n"
docker ps -aq --filter name=$CONTAINER_ID | $xargs_command docker rm -f -v
printf ${green}"...done!"${neutral}"\n"

# Run the container.
printf "\n"${green}"Starting Docker container: geerlingguy/docker-$distro-ansible."${neutral}"\n"
docker run --name=$CONTAINER_ID -d \
  --add-host "$HOSTNAME  drupalvm":127.0.0.1 \
  -v $PWD:/var/www/drupalvm/:$volume_opts \
  $opts \
  geerlingguy/docker-$distro-ansible:latest \
  $init

# Set up directories.
docker exec $CONTAINER_ID mkdir -p /var/www/drupalvm/drupal
[[ ! -z "$config_dir" ]] && docker exec $CONTAINER_ID mkdir -p $config_dir || true

# Copy configuration into place.
docker exec $CONTAINER_ID cp $DRUPALVM_DIR/$CONFIG ${config_dir:-$DRUPALVM_DIR}/config.yml
docker exec $CONTAINER_ID cp $DRUPALVM_DIR/$MAKEFILE ${config_dir:-$DRUPALVM_DIR}/drupal.make.yml
docker exec $CONTAINER_ID cp $DRUPALVM_DIR/$COMPOSERFILE ${config_dir:-$DRUPALVM_DIR}/drupal.composer.json
[[ ! -z "$DRUPALVM_ENV" ]] && docker exec $CONTAINER_ID bash -c "cp $DRUPALVM_DIR/tests/$DRUPALVM_ENV.config.yml ${config_dir:-$DRUPALVM_DIR}/$DRUPALVM_ENV.config.yml" || true

# Override configuration variables with local config.
[[ ! -z "$local_config" ]] && docker exec $CONTAINER_ID bash -c "cp $DRUPALVM_DIR/$local_config ${config_dir:-$DRUPALVM_DIR}/local.config.yml" || true

# Check playbook syntax.
printf "\n"${green}"Checking playbook syntax..."${neutral}"\n"
docker exec --tty $CONTAINER_ID env TERM=xterm ansible-playbook $DRUPALVM_DIR/provisioning/playbook.yml --syntax-check

# Run Ansible Lint.
docker exec $CONTAINER_ID bash -c "pip install ansible-lint"
docker exec $CONTAINER_ID bash -c "cd $DRUPALVM_DIR/provisioning && ansible-lint playbook.yml" || true

# Run the setup playbook.
printf "\n"${green}"Running the setup playbook..."${neutral}"\n"
docker exec --tty $CONTAINER_ID env TERM=xterm ansible-playbook /var/www/drupalvm/tests/test-setup.yml

# Run the Drupal VM playbook.
printf "\n"${green}"Running the Drupal VM playbook..."${neutral}"\n"
if [ ! -z "${config_dir}" ]; then
  # Run with config_dir specified.
  docker exec $CONTAINER_ID env TERM=xterm ANSIBLE_FORCE_COLOR=true DRUPALVM_ENV=$DRUPALVM_ENV \
    ansible-playbook $DRUPALVM_DIR/provisioning/playbook.yml \
    --extra-vars="config_dir=$config_dir";
else
  # Run without config_dir specified.
  docker exec $CONTAINER_ID env TERM=xterm ANSIBLE_FORCE_COLOR=true DRUPALVM_ENV=$DRUPALVM_ENV \
    ansible-playbook $DRUPALVM_DIR/provisioning/playbook.yml;
fi

# Drupal.
printf "\n"${green}"Running functional tests..."${neutral}"\n"
docker exec $CONTAINER_ID curl -sSi --header Host:$HOSTNAME localhost \
  | tee /tmp/dvm-test \
  | grep -q '<title>Welcome to Drupal' \
  && (echo 'Drupal install pass' && exit 0) \
  || (echo 'Drupal install fail' && cat /tmp/dvm-test && exit 1)

# Adminer.
if [ $TEST_INSTALLED_EXTRAS = true ]; then
  docker exec $CONTAINER_ID curl -sSi --header Host:adminer.$HOSTNAME localhost \
    | tee /tmp/dvm-test \
    | grep -q '<title>Login - Adminer' \
    && (echo 'Adminer install pass' && exit 0) \
    || (echo 'Adminer install fail' && cat /tmp/dvm-test && exit 1)
fi

# Pimp My Log.
if [ $TEST_INSTALLED_EXTRAS = true ]; then
  docker exec $CONTAINER_ID curl -sSi --header Host:pimpmylog.$HOSTNAME localhost \
    | tee /tmp/dvm-test \
    | grep -q '<title>Pimp my Log' \
    && (echo 'Pimp my Log install pass' && exit 0) \
    || (echo 'Pimp my Log install fail' && cat /tmp/dvm-test && exit 1)
fi

# MailHog.
if [ $TEST_INSTALLED_EXTRAS = true ]; then
  docker exec $CONTAINER_ID curl -sSi localhost:8025 \
    | tee /tmp/dvm-test \
    | grep -q '<title>MailHog' \
    && (echo 'MailHog install pass' && exit 0) \
    || (echo 'MailHog install fail' && cat /tmp/dvm-test && exit 1)
fi

# Varnish.
if [ $TEST_INSTALLED_EXTRAS = true ]; then
  docker exec $CONTAINER_ID curl -sSI --header Host:$HOSTNAME localhost:81 \
    | tee /tmp/dvm-test \
    | grep -q 'Via: .* varnish' \
    && (echo 'Varnish install pass' && exit 0) \
    || (echo 'Varnish install fail' && cat /tmp/dvm-test && exit 1)
fi

# Dashboard.
docker exec $CONTAINER_ID curl -sSi --header Host:$IP localhost \
  | tee /tmp/dvm-test \
  | grep -q "<li>$IP $HOSTNAME</li>" \
  && (echo 'Dashboard install pass' && exit 0) \
  || (echo 'Dashboard install fail' && cat /tmp/dvm-test && exit 1)

# Drush - see https://github.com/drush-ops/drush/issues/3336. This test would
# also test generated global Drush aliases, but it's currently not working due
# to $reasons.
# docker exec $CONTAINER_ID $DRUSH_BIN @$MACHINE_NAME.$HOSTNAME status \
#   | tee /tmp/dvm-test \
#   | grep -q 'Drupal bootstrap.*Successful' \
#   && (echo 'Drush install pass' && exit 0) \
#   || (echo 'Drush install fail' && cat /tmp/dvm-test && exit 1)

# Drush.
docker exec $CONTAINER_ID bash -c "cd $DRUPALVM_DIR/drupal && $DRUSH_BIN status" \
  | tee /tmp/dvm-test \
  | grep -q 'Drush' \
  && (echo 'Drush install pass' && exit 0) \
  || (echo 'Drush install fail' && cat /tmp/dvm-test && exit 1)

# Remove test container.
if [ $cleanup = true ]; then
  printf "\n"${green}"Cleaning up..."${neutral}"\n"
  docker rm -f $CONTAINER_ID
  printf ${green}"...done!"${neutral}"\n\n"
else
  printf "\n"${green}"Skipping cleanup for container id: ${CONTAINER_ID}!"${neutral}"\n"
  printf ${green}"Done!"${neutral}"\n\n"
fi
