#!/bin/bash
#
# Parse a YAML file.
#
# Usage:
#   parse_yaml [file-path] [variable-to-retrieve]
#
# Requires ruby.
#   @see https://coderwall.com/p/bm_tpa/reading-yaml-files-in-bash-with-ruby
#   @todo Consider using PHP so user doesn't need to install Ruby.

function parse_yaml {
  ruby -ryaml -e 'puts ARGV[1..-1].inject(YAML.load(File.read(ARGV[0]))) {|acc, key| acc[key] }' "$@"
}
