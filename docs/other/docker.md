Drupal VM can be used to bake and share [Docker](https://www.docker.com) images containing a custom prebuilt copy of Drupal VM.

Drupal VM includes a few `composer` scripts and an example `docker-compose.yml` file which allow you to 'bake' a new Docker image using the current Drupal VM configuration, then use this image to quickly build or rebuild your Drupal development environment (or share the image with your development team for _immediate_ environment setup).

> **Docker support is currently experimental**, so you may want to wait until Docker support is more finalized unless you're already familiar with Docker, and okay with potentially backwards-incompatible changes when upgrading Drupal VM.

## Managing your hosts file

Before using Docker to run Drupal VM, you should [edit your hosts file](https://support.rackspace.com/how-to/modify-your-hosts-file/) and add the following line:

    192.168.88.88  drupalvm.dev

...but substituting the IP address and domain name you'd like to use to access your Drupal VM container.

> If you're using Docker for Mac, you need to perform one additional step to ensure you can access Drupal VM using a unique IP address:
>
>   1. Add an alias IP address on the loopback interface: `sudo ifconfig lo0 alias 192.168.88.88/24`
>
> Note that you'll have to create the alias again after restarting your computer. See [this Docker (moby) issue](https://github.com/moby/moby/issues/22753#issuecomment-246054946) for more details.

## Building ('baking') a Docker container with Drupal VM

After you've configured your Drupal VM settings in `config.yml` and other configuration files, run the following command to create and provision a new Docker container:

    [OPTIONS] composer docker-bake

Look at the variables defined in the `provisioning/docker/bake.sh` file for all the currently-available options (e.g. `DRUPALVM_IP_ADDRESS`, `DISTRO`, etc.). You can use Drupal VM's defaults by running the `composer docker-bake` command without any options.

This process can take some time (it should take a similar amount of time as it takes to build Drupal VM normally, using Vagrant and VirtualBox), and at the end, you should see a message like:

```
PLAY RECAP *********************************************************************
localhost                  : ok=210  changed=94   unreachable=0    failed=0


...done!

Visit the Drupal VM dashboard: http://localhost:8080
```

Once the build is complete, you could view the dashboard by visiting the URL provided.

## Saving the Docker container to an image

If you are happy with the way the container was built, you can run the following command to convert the container into an image:

    composer docker-save-image

You can override the default values for the image creation by overriding the following three variables inside `config.yml`:

    docker_container_name: drupal-vm
    docker_image_name: drupal-vm
    docker_image_path: ~/Downloads

Using the default settings, this command will tag your current version of the container as `drupal-vm:latest` (on your local computer), then store an archive of the image in an archive file, in the path "`docker_image_path`/`docker_image_name`.tar.gz".

## Loading the Docker container from an image

On someone else's computer (or your own, if you have deleted the existing `drupal-vm` image), you can load an image archive by placing it in the path defined by "`docker_image_path`/`docker_image_name`.tar.gz" in your `config.yml` file. To do this, run the command:

    composer docker-load-image

## Using Drupal VM with `docker-compose.yml`

Drupal VM includes an `example.docker-compose.yml` file. To use the file, copy it to `docker-compose.yml` and customize as you see fit. Once you've configured the exposed ports and settings as you like, run the following command to bring up the network and container(s) according to the compose file:

    docker-compose up -d

(The `-d` tells `docker-compose` to start the containers and run in the background.) You can stop the containers with `docker-compose stop`, or remove all their configuration with `docker-compose down`.
