#!/bin/bash

. tag_functions.sh

trap 'abort' 0

set -e

## define variables
stan_directory=~/dev/stan-tag
# stan_directory=
old_version=2.5.0
# old_version=
version=2.6.0
# version=

## internal variables
tag_github_url=https://github.com/stan-dev/stan.git
tag_current_step="Stan directory"


########################################
## set up variables
########################################

echo ""
echo "---------- Script to Stan ----------"
if [[ -z $stan_directory ]]; then
  read -p "  Input Stan directory: " stan_directory
fi

## validate stan_directory
tag_current_step="Validating Stan directory: $stan_directory"
if [[ ! -d $stan_directory ]]; then
  tag_current_step="Cloning Stan into $stan_directory"
  eval "git clone $tag_github_url $stan_directory"
fi

pushd $stan_directory > /dev/null
tag_current_step="Verifying Stan in $stan_directory is correct"

if [[ $(git ls-remote --get-url origin) != $tag_github_url ]]; then
  tag_current_step="Wrong repository!
    $stan_directory is cloned from $(git ls-remote --get-url origin)
    Expecting a clone of $tag_github_url"
  exit 1
fi
popd > /dev/null

## reading old Stan version
tag_current_step="Reading current Stan version"
if [[ -z $old_version ]]; then
  tmp=$(read_major_version).$(read_minor_version).$(read_patch_version)
  read -p "  Current Stan version (leave blank for: $tmp): " old_version
  if [[ -z $old_version ]]; then
    old_version=$tmp
  fi
fi

tag_current_step="Verifying current Stan version"
if ! check_version $old_version; then
  tag_current_step="Invalid old version: \"$old_version\""
  exit 1
fi
if [[ $(read_major_version) -ne $(major_version $old_version) ]]; then
  tag_current_step="Invalid old version: \"$old_version\"
    Expecting major version: $(read_major_version)"
  exit 1
fi
if [[ $(read_minor_version) -ne $(minor_version $old_version) ]]; then
  tag_current_step="Invalid old version: \"$old_version\"
    Expecting minor version: $(read_minor_version)"
  exit 1
fi
if [[ $(read_patch_version) -ne $(patch_version $old_version) ]]; then
  tag_current_step="Invalid old version: \"$old_version\"
    Expecting patch version: $(read_patch_version)"
  exit 1
fi


## reading new Stan version
tag_current_step="Reading new Stan version"
if [[ -z $version ]]; then
  read -p "  New Stan version (old version: $old_version): " version
fi

tag_current_step="Verifying new Stan version"
if ! check_version $version; then
  tag_current_step="Invalid new version: \"$version\""
  exit 1
fi
if [[ $old_version == $version ]]; then
  tag_current_step="Invalid new version!
    Trying to tag the same version: \"$version\""
  exit 1
fi

########################################
## 1. $stan_home should be clean and
##    up to date
########################################
tag_current_step="Checking $stan_home"
pushd $stan_directory > /dev/null

if [[ -n $(git status --porcelain) ]]; then
  tag_current_step="$stan_home is not clean!
    Verify the directory passes \"git status --porcelain\""
  exit 1
fi

git checkout develop
git pull --ff

popd > /dev/null










trap : 0 

exit 0
