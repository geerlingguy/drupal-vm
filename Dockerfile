FROM geerlingguy/docker-debian9-ansible:latest
LABEL maintainer="Jeff Geerling"

# Copy provisioning directory, variable overrides, and scripts into container.
COPY ./ /etc/ansible/drupal-vm
COPY ./provisioning/docker/vars/docker-hub-overrides.yml /etc/ansible/drupal-vm/local.config.yml
COPY ./provisioning/docker/bin/* /usr/local/bin

# Provision Drupal VM inside Docker.
RUN ansible-playbook /etc/ansible/drupal-vm/provisioning/playbook.yml \
  # Enable FPM. See https://github.com/geerlingguy/drupal-vm/issues/1366.
  && systemctl enable php7.1-fpm.service

EXPOSE 80 443 3306 8025

CMD ["/lib/systemd/systemd"]
