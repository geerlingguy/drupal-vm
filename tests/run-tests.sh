#!/bin/bash

# Set volume options.
if [[ "$OSTYPE" == "darwin"* ]]; then
  volume_opts='rw,cached'
else
  volume_opts='rw'
fi

# Remove test container if it already exists.
docker ps -aq --filter name=dvm-test | xargs docker rm -f -v

# Run the container.
docker run --name=dvm-test -d \
  --add-host "$HOSTNAME  drupalvm":127.0.0.1 \
  -v $PWD:/var/www/drupalvm/:$volume_opts \
  -p 8888:80 \
  --privileged \
  geerlingguy/docker-ubuntu1604-ansible:latest \
  /lib/systemd/systemd

# Create Drupal directory.
docker exec dvm-test mkdir -p /var/www/drupalvm/drupal

# Check playbook syntax.
docker exec --tty dvm-test env TERM=xterm ansible-playbook /var/www/drupalvm/provisioning/playbook.yml --syntax-check

# Set things up and run the Ansible playbook.
docker exec --tty dvm-test env TERM=xterm ansible-playbook /var/www/drupalvm/tests/test-setup.yml
docker exec dvm-test env TERM=xterm ANSIBLE_FORCE_COLOR=true COMPOSER_PROCESS_TIMEOUT=1800 ansible-playbook /var/www/drupalvm/provisioning/playbook.yml

# Check if Drupal was installed successfully.
docker exec dvm-test curl -s --header Host:$HOSTNAME localhost \
  | grep -q '<title>Welcome to Drupal' \
  && (echo 'Drupal install pass' && exit 0) \
  || (echo 'Drupal install fail' && exit 1)

# Remove test container.
docker rm -f dvm-test
