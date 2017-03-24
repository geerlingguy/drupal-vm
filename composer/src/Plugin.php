<?php
/**
 * @file
 * Contains JJG\DrupalVM|Plugin.
 */

namespace JJG\DrupalVM;

use Composer\Composer;
use Composer\EventDispatcher\EventSubscriberInterface;
use Composer\Factory;
use Composer\IO\IOInterface;
use Composer\Plugin\PluginInterface;
use Composer\Script\Event;
use Composer\Script\ScriptEvents;

class Plugin implements PluginInterface, EventSubscriberInterface {

    /**
     * @var \Composer\Composer
     */
    protected $composer;

    /**
     * @var \Composer\IO\IOInterface
     */
    protected $io;

    /**
     * {@inheritdoc}
     */
    public function activate(Composer $composer, IOInterface $io) {
        $this->composer = $composer;
        $this->io = $io;
    }

    /**
     * {@inheritdoc}
     */
    public static function getSubscribedEvents() {
        return array(
            ScriptEvents::POST_INSTALL_CMD => 'addVagrantfile',
            ScriptEvents::POST_UPDATE_CMD => 'addVagrantfile',
        );
    }

    /**
     * Add/update project Vagrantfile.
     *
     * @param \Composer\Script\Event $event
     */
    public function addVagrantfile(Event $event) {

        $baseDir = dirname(Factory::getComposerFile());
        $source = __DIR__ . '/../../Vagrantfile';
        $target =  $baseDir . '/Vagrantfile';

        if (file_exists($source)) {
            if (!file_exists($target) || md5_file($source) != md5_file($target)) {
                copy($source, $target);
            }
        }
    }

}
