# Drupal VM - Ansible Provisioning

Drupal VM uses the Ansible provisioner to build all the software that runs and supplements Drupal sites.

The Ansible configuration uses a variety of open source community-maintained Ansible Roles that are hosted on Ansible Galaxy, but Drupal VM includes the roles in the codebase for efficiency's sake.

**You should NOT make any manual changes to the roles in the `roles` directory**, but rather, contribute to the upstream roles corresponding to the role's folder name (e.g. for issues with the `geerlingguy.apache` role, see the [`geerlingguy.apache`](https://galaxy.ansible.com/geerlingguy/apache/) role page on Ansible Galaxy, and the role's [issue tracker on GitHub](https://github.com/geerlingguy/ansible-role-apache/issues)).

## Adding and Updating Galaxy roles

From time to time, third party roles need to be added or updated to enable new Drupal VM functionality or fix bugs. To update a role (e.g. `geerlingguy.apache`), find the role's `version` setting inside `requirements.yml`, bump the version to the required or latest version of the role, then run the following command _in the same directory as this README file_:

    $ ansible-galaxy install -r requirements.yml --force

Then commit the updated `requirements.yml` file and the new and updated files within the `roles` directory in a new PR to the Drupal VM project.
