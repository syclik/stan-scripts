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
  sed -e 's/^.*MAJOR_VERSION[[:space:]]*=[[:space:]]*\"\(.*\)\".*/\1/p' -n $stan_directory/src/stan/version.hpp 
}

read_minor_version() {
  sed -e 's/^.*MINOR_VERSION[[:space:]]*=[[:space:]]*\"\(.*\)\".*/\1/p' -n $stan_directory/src/stan/version.hpp 
}

read_patch_version() {
  sed -e 's/^.*PATCH_VERSION[[:space:]]*=[[:space:]]*\"\(.*\)\".*/\1/p' -n $stan_directory/src/stan/version.hpp 
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

replace_major_version() {
  sed -i '' "s/\(^.*MAJOR_VERSION[[:space:]]*=[[:space:]]*\"\)\(.*\)\(\"\)/\1$(major_version $1)\3/g" $stan_directory/src/stan/version.hpp 
}

replace_minor_version() {
  sed -i '' "s/\(^.*MINOR_VERSION[[:space:]]*=[[:space:]]*\"\)\(.*\)\(\"\)/\1$(minor_version $1)\3/g" $stan_directory/src/stan/version.hpp 
}

replace_patch_version() {
  sed -i '' "s/\(^.*PATCH_VERSION[[:space:]]*=[[:space:]]*\"\)\(.*\)\(\"\)/\1$(patch_version $1)\3/g" $stan_directory/src/stan/version.hpp 
}

replace_version() {
  for file in "$@"
  do
    sed -i '' "s/$(major_version $old_version)\.$(minor_version $old_version)\.$(patch_version $old_version)/$(major_version $version)\.$(minor_version $version)\.$(patch_version $version)/g" $file
  done
}
