![Drupal VM Logo](https://raw.githubusercontent.com/geerlingguy/drupal-vm/master/docs/images/drupal-vm-logo.png)

[![Build Status](https://travis-ci.org/geerlingguy/drupal-vm.svg?branch=master)](https://travis-ci.org/geerlingguy/drupal-vm) [![Documentation Status](https://readthedocs.org/projects/drupal-vm/badge/?version=latest)](http://docs.drupalvm.com) [![Packagist](https://img.shields.io/packagist/v/geerlingguy/drupal-vm.svg)](https://packagist.org/packages/geerlingguy/drupal-vm) [![Docker Automated build](https://img.shields.io/docker/automated/geerlingguy/drupal-vm.svg?maxAge=2592000)](https://hub.docker.com/r/geerlingguy/drupal-vm/) [![](https://images.microbadger.com/badges/image/geerlingguy/drupal-vm.svg)](https://microbadger.com/images/geerlingguy/drupal-vm "Get your own image badge on microbadger.com") [![irc://irc.freenode.net/drupal-vm](https://img.shields.io/badge/irc.freenode.net-%23drupal--vm-brightgreen.svg)](https://riot.im/app/#/room/#drupal-vm:matrix.org)

[Drupal VM](https://www.drupalvm.com/) Es un VM para Drupal, construido con Ansible.

Drupal VM hace que la construcción de entornos de desarrollo Drupal sea rápido y fácil, y presenta a los programadores al maravilloso mundo del programador Drupal en máquinas virtuales o contenedores Docker (en vez del viejo programador MAMP/WAMP-based).

Instalará los siguientes en un Ubuntu 16.04 (predeterminado) linux VM:

  - Apache 2.4.x (o Nginx)
  - PHP 7.1.x (configurable)
  - MySQL 5.7.x (o MariaDB, o PostgreSQL)
  - Drupal 7 o 8
  - Optional:
    - Drupal Console
    - Drush
    - Varnish 4.x (configurable)
    - Apache Solr 4.10.x (configurable)
    - Elasticsearch
    - Node.js 0.12 (configurable)
    - Selenium, para probar el sitio vía Behat
    - Ruby
    - Memcached
    - Redis
    - SQLite
    - Blackfire, XHProf, o Tideways para perfilar tu código
    - XDebug, para reparar tu código
    - Adminer, para acceder directamente a la base de datos
    - Pimp my Log, para facilitar la vista de archivos de inicio de sesión
    - MailHog, para detectar y reparar el correo

Debería tomar alrededor de 5-10 minutos para construir o reconstruir el VM desde cero en una decente conexión de banda ancha.

Porfavor lea mediante el resto de este README y la [documentación Drupal VM](http://docs.drupalvm.com/) por ayuda obteniendo la configuración Drupal VM e integrarlo a tu ritmo de trabajo.

## Documentación

La documentación completa de Drupal VM está disponible en http://docs.drupalvm.com/

## Personaliza el VM

Existen varios lugares donde puedes personalizar el VM para tus necesidades:

  - `config.yml`: Anula cualquier configuración VM predeterminada desde `default.config.yml`; Personaliza casi cualquier aspecto en cualquier software instalado en VM (lea más sobre [configurando Drupal VM](http://docs.drupalvm.com/en/latest/getting-started/configure-drupalvm/).
  - `drupal.composer.json` o `drupal.make.yml`: Contiene una configuración para la versión central Drupal, modulos, y parches que serán descargados en la instalación inicial de Drupal (puedes construir utilizando Composer, Drush make, o tu propia base de código).

Si quieres cambiar a Drupal 8 (predeterminado) a Drupal 7 en la instalación inicial, haz lo siguiente:

  1. Cambia a utilizar un [archivo Drush Make](http://docs.drupalvm.com/en/latest/deployment/drush-make/).
  1. Actualiza la `version` y `core` Drupal dentro de tu archivo `drupal.make.yml`.
  2. Establece la `drupal_major_version: 7` dentro de `config.yml`.

## Guía de Inicio Rápido

Esta guía de inicio rápido te ayudará a construir rapidamente un sitio Drupal 8 utilizando el Drupal VM Composer con `drupal-project`. También puedes utilizar el Drupal VM con [Composer](http://docs.drupalvm.com/en/latest/deployment/composer/), un [archivo Drush Make](http://docs.drupalvm.com/en/latest/deployment/drush-make/), with a [Local Drupal codebase](http://docs.drupalvm.com/en/latest/deployment/local-codebase/), o incluso una [instalación de Drupal multisite](http://docs.drupalvm.com/en/latest/deployment/multisite/).

Si quieres instalar el sitio Drupal 8 localmente sin el más mínimo alboroto, simplemente:

  1. Instala [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
  2. Descarga o clona este proyecto a tu puesto de trabajo.
  3. `cd` en el directorio de este proyecto y ejecuta `vagrant up`.

Pero Drupal VM te permite construir tu sitio exactamente como gustes, utilizando cualquier herramienta que necesites, ¡Con una flexibilidad y personalización casi infinitas!

### 1 - Instala Vagrant y VirtualBox

Descarga e instala [Vagrant](https://www.vagrantup.com/downloads.html) y [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

También puedes utilizar un proveedor alternativo como Parallels o VMware. (Parallels Desktop 11+ requiere la edición "Pro" o "Business" y el [Proveedor de Parallels](http://parallels.github.io/vagrant-parallels/), y VMware requiere el complemento de integración pago [Vagrant VMware](http://www.vagrantup.com/vmware)).

Notas:

  - **Para una provisión más rápida** (macOS/Linux only): *[Instala Ansible](http://docs.ansible.com/intro_installation.html) en tu máquina host, para que Drupal VM pueda ejecutar localmente los pasos de provisión en vez de adentro de VM.*
  - **Para estabilidad**: Porque cada versión de VirtualBox introduce cambios en las redes, para la mejor estabilidad, deberás instalar el complemento Vagrant's `vbguest`: `vagrant plugin install vagrant-vbguest`.
  - **NFS en Linux**: *Si NFS no está ya instalado en tu host, necesitarás instalar la configuración de la carpeta NFS synced predeterminada. Lee las guías para [Debian/Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-14-04), [Arch](https://wiki.archlinux.org/index.php/NFS#Installation), y [RHEL/CentOS](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-centos-6).*
  - **Las Versiones**: *Asegurate de que se estas ejecutando las últimas versiones de Vagrant, VirtualBox, y Ansible—as de finales del 2016, Drupal VM recomienda: Vagrant 1.8.6, VirtualBox 5.1.10+, y Ansible 2.2.x*

### 2 - Contruye una máquina virtual

  1. Descarga este proyecto y colocalo donde quieras.
  2. (Opcional) Copia `default.config.yml` a `config.yml` y modificalo a tu gusto.
  3. Crea un directorio local donde Drupal será instalado y configura el path a ese directorio en `config.yml` (`local_path`, dentro `vagrant_synced_folders`).
  4. Abre una terminal, `cd` a este directorio (que contenga el archivo `Vagrantfile` y este README).
  5. Escribe en `vagrant up`, y deja que Vagrant haga su magia.

Una vez completado el proceso, tendrás una base de código Drupal disponible dentro del directorio `drupal/` del proyecto.

Nota: *Si hay errores durante el curso de ejecución de `vagrant up`, y te devuelve a tu símbolo del sistema, solo ejecuta `vagrant provision` para seguir construyendo el VM donde lo dejaste. Si aún hay errores luego de haber hecho esto algunas veces, publica un issue al buscador de issue en este proyecto en GitHub.*

### 3 - Accede al VM.

Abre el navegador y accede a [http://drupalvm.test/](http://drupalvm.test/). El inicio de sesión predeterminado para la cuenta de administrador es `admin` para el nombre de usuario y la contraseña.

Nota: *Drupal VM por defecto está configurado para utilizar `192.168.88.88` como su IP, si estas ejecutando multiples VM's el complemento `auto_network` (`vagrant plugin install vagrant-auto_network`) puede ayudar gestionando una dirección de IP si estableces `vagrant_ip` a `0.0.0.0` dentro de `config.yml`.*

## Utilidades extras del software

Por defecto, este VM incluye los extras ennumerados `config.yml` en la opción `installed_extras`:

    extras_instalados:
      - adminer
      # - blackfire
      # - drupalconsole
      - drush
      # - elasticsearch
      # - java
      - mailhog
      # - memcached
      # - newrelic
      # - nodejs
      - pimpmylog
      # - redis
      # - ruby
      # - selenium
      # - solr
      # - tideways
      # - upload-progress
      - varnish
      # - xdebug
      # - xhprof

Si no quieres o no necesitas más de estos extras, solo eliminalos o comentalos de la lista. Esto es útil si quieres reducir el uso de memoria PHP o de lo contrario conserva los recursos del sistema.

## Utilizando Drupal VM

Drupal VM fue hecho para ser integrado al ritmo de trabajo de un programador. Existen muchas guías para utilizar Drupal VM para tareas sencillas de programación están disponibles en [sitio de documentación Drupal VM](http://docs.drupalvm.com).

## Actualizando Drupal VM

Drupal VM sigue las versiones semánticas, lo que significa que tu configuración deberia seguir funcionando (potencialmente con modificaciones muy menores) durante los ciclos de nuevos lanzamientos. Aquí está el proceso a seguir cuando actualices Drupal VM entre lanzamientos menores:

  1. Lea a través de las [Notas de lanzamiento](https://github.com/geerlingguy/drupal-vm/releases) y añada o modifique `config.yml` las variables mencionadas allí.
  2. Haz una diferencia en su `config.yml` con la `default.config.yml` actualizada (p.ej. `curl https://raw.githubusercontent.com/geerlingguy/drupal-vm/master/default.config.yml | git diff --no-index config.yml -`).
  3. Ejecute `vagrant provision` para provisionar el VM, incorporando todos los últimos cambios.

Para las actualizaciones de versiones (p.ej. 2.x.x to 3.x.x), puede ser más sencillo destruir el VM (`vagrant destroy`) y luego construir un nuevo VM (`vagrant up`) utilizando la nueva versión de Drupal VM.

## Requerimientos del Sistema

Drupal VM es ejecutable en casi cualquier computador moderno que pueda ejecutar VirtualBox y Vagrant, sin embargo para la mejor experiencia posible, es recomendable que tengas una computadora con al menos:

  - Procesador Intel Core con VT-x habilitado
  - Al menos 4 GB de RAM (mientras más, mejor)
  - Un SSD (para mayor velocidad con carpetas sincronizadas)

## Otras Notas

  - Para desconectar la máquina virtual, entra a `vagrant halt` en  la terminal de la misma carpeta que contiene el `Vagrantfile`. para destruirlo completamente (si quieres salvar un poco de espacio en el disco, o quieres reconstruirlo desde cero con `vagrant up` nuevamente), escribe `vagrant destroy`.
  - para iniciar sesión en la máquina virtual, envíe `vagrant ssh`. También puedes obtener los detalles de conexión SSH de la máquina con `vagrant ssh-config`.
  - Cuando reconstruyes el VM (p.ej. `vagrant destroy` y luego otro `vagrant up`), asegurate de limpiar los contenidos de la carpeta `drupal` en tu máquina host, o Drupal devolverá algunos errores cuando el VM sea reconstruido (no se reinstalará Drupal limpiamente).
  - Puedes cambiar la versión instalada de Drupal o drush, o cualquier otra opción de configuración, editando las variables dentro de `config.yml`.
  - Descubre más sobre programación local con Vagrant + VirtualBox + Ansible en esta presentación: [Local Development Environments - Vagrant, VirtualBox and Ansible](http://www.slideshare.net/geerlingguy/local-development-on-virtual-machines-vagrant-virtualbox-and-ansible).
  - Aprende sobre como Ansible puede acelerar tu habilidad para innovar y manejar tu infraestructura leyendo [Ansible for DevOps](http://www.ansiblefordevops.com/).

## Pruebas

Para ejecutar pruebas básicas de integración utilizando Docker:

  1. [Instala Docker](https://docs.docker.com/engine/installation/).
  2. En el directorio de este proyecto, ejecute: `composer run-tests`

> Nota: Si utilizas una a Mac, necesitarás utilizar [Docker's Edge release](https://docs.docker.com/docker-for-mac/install/#download-docker-for-mac), al menos hasta que [este issue](https://github.com/docker/for-mac/issues/77) sea resuelto.

Las pruebas automaticas de este proyecto se ejecutan vía Travis CI, y un conjunto de pruebas más completo que abarca múltiples distribuciones de Linux y muchos casos de uso de Drupal VM y diferentes técnicas de implementació.

## Licencia

Este proyecto está licenciado bajo la licencia MIT de código abierto.

## Sobre el Autor

[Jeff Geerling](https://www.jeffgeerling.com/) creó Drupal VM en el 2014 para un sitio Drupal de ritmo de trabajo de programación core/contrib más eficiente. este proyecto se presenta como un ejemplo en [Ansible for DevOps](https://www.ansiblefordevops.com/).
