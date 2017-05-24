You can deploy a codebase directly inside Drupal VM via Git. You can deploy a Git-based Drupal site directly into a shared folder, or you can even deploy inside Drupal VM's own filesystem. The latter option offers better performance than any of the other deployment methods, since Drupal VM can use native filesystem caches and disk access.

This is also the recommended method for deploying Drupal sites to Drupal VM when used [in production](../other/production.md)

## Deploying Drupal via Git

Drupal VM uses the [`geerlingguy.drupal`](https://github.com/geerlingguy/ansible-role-drupal) Ansible role to deploy and manage Drupal codebases.

To deploy your Drupal project inside Drupal VM during provisioning, you need to set the following variables inside `config.yml`:

    drupal_deploy: true
    drupal_deploy_repo: "git@github.com:username/example.git"
    drupal_deploy_dir: /var/www/drupal

The above settings assume you want to deploy a Drupal codebase in the GitHub repository `username/example.git` (or any other valid Git URL to which you have access). And it will place that codebase inside `/var/www/drupal`, which you might have mounted as a shared folder, or if you want even better performance, you could configure a 'reverse mount' or just work on the codebase inside the VM.

If you want to disable Drupal VM's default synced folder, set the following variable in `config.yml`:

    vagrant_synced_folders: []

When you run `vagrant provision` or deploy Drupal VM to a production server, the `geerlingguy.drupal` role will check out the Git repository into the `drupal_deploy_dir`.

> Note: For private repositories, you can use your own SSH key if you use `ssh-agent`. On Mac or Linux, you can run `ssh-add -K` to add your default private key to the SSH Agent, or on Windows you can either use [Pageant](https://winscp.net/eng/docs/ui_pageant), an SSH agent built into your CLI emulator, or if you're on Windows 10, the SSH Agent that's installed with Ubuntu Bash.

For more information about this technique, please read Jeff Geerling's blog post, [Drupal VM on Windows - a fast container for BLT project development](https://www.jeffgeerling.com/blog/2017/drupal-vm-on-windows-fast-container-blt-project-development). Note that this technique is great for better performance on Windows, but it can be used on any platform where Drupal VM is used.
