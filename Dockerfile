FROM geerlingguy/docker-debian8-ansible:latest
MAINTAINER Jeff Geerling

# Copy provisioning directory into VM.
COPY ./ /etc/ansible/drupal-vm

# Provision Drupal VM inside Docker.
RUN ANSIBLE_FORCE_COLOR=true \
  ansible-playbook /etc/ansible/drupal-vm/provisioning/playbook.yml \
  --extra-vars="hostname_configure=false firewall_enabled=false"

EXPOSE 22 80 81 443 8025
