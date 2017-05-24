Drupal VM can be used with [Docker](https://www.docker.com) instead of or in addition to Vagrant:

  - You can build a local instance using Docker, pulling the official [`geerlingguy/drupal-vm`](https://hub.docker.com/r/geerlingguy/drupal-vm/) image.
  - You can 'bake your own' customized Drupal VM Docker image and reuse it or share it with your team.

> **Docker support is currently experimental**, so unless you're already familiar with Docker, it might be best to wait until later versions of Drupal VM are released with more stable support.

## Managing your hosts file

Before using Docker to run Drupal VM, you should [edit your hosts file](https://support.rackspace.com/how-to/modify-your-hosts-file/) and add the following line:

    192.168.88.88  drupalvm.dev

(Substitute the IP address and domain name you'd like to use to access your Drupal VM container.)

You can also add other subdomains if you're using other built-in services, e.g. `adminer.drupalvm.dev`, `xhprof.drupalvm.com`, etc.

> If you're using Docker for Mac, you need to perform one additional step to ensure you can access Drupal VM using a unique IP address:
>
>   1. Add an alias IP address on the loopback interface: `sudo ifconfig lo0 alias 192.168.88.88/24`
>
> Note that you'll have to create the alias again after restarting your computer. See [this Docker (moby) issue](https://github.com/moby/moby/issues/22753#issuecomment-246054946) for more details.

## Method 1: Build a default Drupal VM instance with Docker

The [`geerlingguy/drupal-vm`](https://hub.docker.com/r/geerlingguy/drupal-vm/) image on Docker Hub contains a pre-built copy of Drupal VM, with all the latest Drupal VM defaults. If you need to quickly run your site in a container, or don't need to customize any of the components of Drupal VM, you can use this image.

> For a reference installation that has configuration for running the local environment on _either_ Vagrant or Docker, see the [Drupal VM Live Site Repository](https://github.com/geerlingguy/drupalvm-live).

### (Optional) Add a `Dockerfile` for customization

If you need to make small changes to the official `drupal-vm` image (instead of baking your own fully-custom image), you can create a `Dockerfile` to make those changes. In one site's example, ImageMagick was required for some media handling functionality, and so the following `Dockerfile` was places in the project's root directory (alongside the `docker-compose.yml` file):

    FROM geerlingguy/drupal-vm:latest
    MAINTAINER Jeff Geerling
    
    # Install imagemagick.
    RUN apt-get install -y imagemagick
    
    EXPOSE 80 443 3306 8025

You can customize the official image in many other ways, but if you end up doing more than a step or two in a `Dockerfile`, it's probably a better idea to 'bake you own' Drupal VM Docker image.

### Add a `docker-compose.yml` file

Copy the `example.docker-compose.yml` file out of Drupal VM (or grab a copy from GitHub [here](https://github.com/geerlingguy/drupal-vm/blob/master/example.docker-compose.yml)), rename it `docker-compose.yml`, and place it in your project root.

  - _If you are using your own `Dockerfile` to further customize Drupal VM_, comment out the `image: drupal-vm` line, and uncomment the `build: .` line (this tells Docker Compose to build a new image based on your own `Dockerfile`).
  - _If you're not using your own `Dockerfile`_, change the `image` line to: `image: geerlingguy/drupal-vm`.

For the `volume:` definition in `docker-compose.yml`, Drupal VM's default docroot is `/var/www/drupalvm/drupal/web`, which follows the convention of a typical Drupal project built with Composer. If you don't get your site when you attempt to access Drupal VM, you will either need to modify the `volume:` definition to match your project's structure, or use a custom `Dockerfile` and copy in a customized Apache `vhosts.conf` file.

### Run Drupal VM

Run the command `docker-compose up -d` (the `-d` tells `docker-compose` to start the containers and run in the background).

This command takes the instructions in the Docker Compose file and does two things:

  1. Creates a custom Docker network that exposes Drupal VM on the IP address you have configured in `docker-compose.yml` (by default, `192.168.88.88`).
  2. Runs Drupal VM using the configuration in `docker-compose.yml`.

After the Drupal VM container is running, you should be able to see the Dashboard page at the VM's IP address (e.g. `http://192.168.88.88`), and you should be able to access your site at the hostname you have configured in your hosts file (e.g. `http://drupalvm.dev/`).

> Note: If you see Drupal's installer appear when accessing the site, that means the codebase was found, but either the database connection details are not in your local site configuration, or they are, but you don't have the default database populated yet. You may need to load in the database either via `drush sql-sync` or by importing a dump into the container. The default credentials are `drupal` and `drupal` for username and password, and `drupal` for the database name.

You can stop the container with `docker-compose stop` (and start it again with `docker-compose start`), or remove all the configuration with `docker-compose down` (warning: this will also wipe out the database and other local container modifications).

### Using Drush inside Docker

Currently, the easiest way to use Drupal VM's `drush` inside a Docker container is to use `docker exec` to run `drush` internally. There are a few other ways you can try to get Drush working with a codebase running on a container, but the easiest way is to run a command like:

    docker exec drupal-vm bash -c "drush --uri=drupalvm.dev --root=/var/www/drupalvm/drupal/web status"

## Method 2: 'Bake and Share' a custom Drupal VM Docker image

If you need a more customized Drupal VM instance, it's best to build your own with Drupal VM's built-in Docker scripts.

### Building ('baking') a Docker container with Drupal VM

After you've configured your Drupal VM settings in `config.yml` and other configuration files, run the following command to create and provision a new Docker container:

    [OPTIONS] composer docker-bake

Look at the variables defined in the `provisioning/docker/bake.sh` file for all the currently-available options (e.g. `DRUPALVM_IP_ADDRESS`, `DISTRO`, etc.). You can use Drupal VM's defaults by running the `composer docker-bake` command without any options.

This process can take some time (it should take a similar amount of time as it takes to build Drupal VM normally, using Vagrant and VirtualBox), and at the end, you should see a message like:

```
PLAY RECAP *********************************************************************
localhost                  : ok=210  changed=94   unreachable=0    failed=0


...done!

Visit the Drupal VM dashboard: http://192.168.88.88:80
```

Once the build is complete, you could view the dashboard by visiting the URL provided.

### Saving the Docker container to an image

If you are happy with the way the container was built, you can run the following command to convert the container into an image:

    composer docker-save-image

You can override the default values for the image creation by overriding the following three variables inside `config.yml`:

    docker_container_name: drupal-vm
    docker_image_name: drupal-vm
    docker_image_path: ~/Downloads

Using the default settings, this command will tag your current version of the container as `drupal-vm:latest` (on your local computer), then store an archive of the image in an archive file, in the path "`docker_image_path`/`docker_image_name`.tar.gz".

### Loading the Docker container from an image

On someone else's computer (or your own, if you have deleted the existing `drupal-vm` image), you can load an archived image by placing it in the path defined by "`docker_image_path`/`docker_image_name`.tar.gz" in your `config.yml` file. To do this, run the command:

    composer docker-load-image

### Using a baked Drupal VM image with `docker-compose.yml`

Drupal VM includes an `example.docker-compose.yml` file. To use the file, copy it to `docker-compose.yml` and customize as you see fit. Once you've configured the exposed ports and settings as you like, run the following command to bring up the network and container(s) according to the compose file:

    docker-compose up -d

(The `-d` tells `docker-compose` to start the containers and run in the background.) You can stop the container with `docker-compose stop` (and start it again with `docker-compose start`), or remove all the configuration with `docker-compose down` (warning: this will also wipe out the database and other local container modifications).
