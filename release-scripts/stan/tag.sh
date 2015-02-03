#!/bin/bash

. tag_functions.sh

trap 'abort' 0

set -e

echo ""
echo "---------- Script to Stan ----------"


## define variables
stan_directory=~/dev/stan-tag
# stan_directory=
old_version=2.5.0
# old_version=
version=2.6.0
# version=
github_user=syclik
#github_user=
github_password=
#github_user=


## internal variables
tag_github_url=https://github.com/stan-dev/stan.git
tag_current_step="Stan directory"

_steps=("Set up variables" "Create release branch using git")


echo ""
echo "---------- Script to Stan ----------"
echo ""

for n in "${#_stes[@]}"
do
  echo $n
done
echo "------------------------------------"

exit 0

########################################
## set up variables
########################################
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

## read GitHub user name
tag_current_step="Reading GitHub user name"
if [[ -z $github_user ]]; then
  read -p "  Github user name: " github_user
fi

## read GitHub user name
tag_current_step="Reading Github password"
if [[ -z $github_password ]]; then
  read -s -p "  Github password (user: $github_user): " github_password
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


########################################
## 2. git branch to release/v$version
########################################
tag_current_step="Creating release/v$version branch"
pushd $stan_directory > /dev/null

git checkout -b release/v$version

popd > /dev/null


########################################
## 3. Update version numbers
########################################
tag_current_step="Updating version numbers"
pushd $stan_directory > /dev/null

## src/stan/version.hpp
tag_current_step="Updating version numbers: $stan_directory/src/stan/version.hpp"
replace_major_version $version
replace_minor_version $version
replace_patch_version $version
if [[ $(read_major_version) != $(major_version $version) \
    || $(read_minor_version) != $(minor_version $version) \
    || $(read_patch_version) != $(patch_version $version) ]]; then
  tag_current_step="Updating version numbers failed!
    Check $stan_directory/src/stan/version.hpp"
  exit 1
fi

replace_version $(grep -rlF --exclude={*.hpp,*.cpp} "$old_version" $stan_directory/src)

popd > /dev/null


########################################
## 4. Git add and commit changed files
########################################
tag_current_step="Committing changed files to local git repository"
pushd $stan_directory > /dev/null


git commit -m "release/v$version: updating version numbers" -a

popd > /dev/null


########################################
## 5. Build documentation
########################################
tag_current_step="Building documentation"
pushd $stan_directory > /dev/null

make manual doxygen > /dev/null

popd > /dev/null


########################################
## 6. Git add and commit built documentation
########################################
tag_current_step="Committing built documentation"
pushd $stan_directory > /dev/null

git add -f doc
git commit -m "release/v$version: adding built documentation"

popd > /dev/null


########################################
## 7. Final test. Git push
## FIXME!!
########################################
tag_current_step="Pushing changes to github"
pushd $stan_directory > /dev/null

### Add testing code here
git push origin release/v$version

popd > /dev/null



########################################
## 8. Create github pull request
## FIXME!!
########################################
tag_current_step="Create github pull request for $version"
pushd $stan_directory > /dev/null

curl --user "$github_user"

## git push origin release/v$version

popd > /dev/null




########################################
## 10. 
## FIXME!!
########################################

########################################
## 11. 
## FIXME!!
########################################

########################################
## 12. 
## FIXME!!
########################################

########################################
## 13. 
## FIXME!!
########################################

########################################
## 14. 
## FIXME!!
########################################

########################################
## 15. 
## FIXME!!
########################################

########################################
## 16. 
## FIXME!!
########################################

########################################
## 17. 
## FIXME!!
########################################



trap : 0 

exit 0


