FROM geerlingguy/docker-debian8-ansible:latest
MAINTAINER Jeff Geerling

# Copy provisioning directory and vars files into container.
COPY ./ /etc/ansible/drupal-vm
COPY ./provisioning/docker/vars/overrides-no-install.yml /etc/ansible/drupal-vm/local.config.yml

# Provision Drupal VM inside Docker.
RUN ansible-playbook /etc/ansible/drupal-vm/provisioning/playbook.yml

EXPOSE 22 80 443 8025
