#!/bin/bash

## pretty printing for when the shell aborts
## script uses: $tag_current_step
abort() {
  echo "
********************
An error occurred:

  $tag_current_step

Exiting without tagging." >&2

  exit 1
}

read_major_version() {
  sed -e 's/.*MAJOR_VERSION = \"\(.*\)\".*/\1/p' -n $stan_directory/src/stan/version.hpp 
}

read_minor_version() {
  sed -e 's/.*MINOR_VERSION = \"\(.*\)\".*/\1/p' -n $stan_directory/src/stan/version.hpp 
}

read_patch_version() {
  sed -e 's/.*PATCH_VERSION = \"\(.*\)\".*/\1/p' -n $stan_directory/src/stan/version.hpp 
}

check_version() {
  [[ $(grep -o "\." <<<$1 | wc -l) -eq 2 ]]
}

major_version() {
  sed 's/\(.*\)\.\(.*\)\.\(.*\)/\1/' <<<$1
}

minor_version() {
  sed 's/\(.*\)\.\(.*\)\.\(.*\)/\2/' <<<$1
}

patch_version() {
  sed 's/\(.*\)\.\(.*\)\.\(.*\)/\3/' <<<$1
}
