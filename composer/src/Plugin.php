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
                $isLegacy = $this->isLegacyVagrantfile($target);

                copy($source, $target);

                $extra = $this->composer->getPackage()->getExtra();
                if ($isLegacy && !isset($extra['drupalvm']['config_dir'])) {
                    $this->io->writeError(
                        '<warning>'
                        . 'Drupal VM has been updated and consequently written over your Vagrantfile which from now on will be managed by Drupal VM. '
                        . 'Due to this change, you are required to set the `config_dir` location in your composer.json file:'
                        . "\n"
                        . "\n  $ composer config extra.drupalvm.config_dir <sub-directory>"
                        . "\n"
                        . '</warning>'
                    );
                }
            }
        }
    }

    /**
     * Return if the parent project is using the < 5.0.0 delegating Vagrantfile.
     *
     * @return bool
     */
    private function isLegacyVagrantfile($vagrantfile) {
        if (!file_exists($vagrantfile)) {
            return false;
        }
        return strpos(file_get_contents($vagrantfile), '# Load the real Vagrantfile') !== false;
    }
}
