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
github_user=syclik
#github_user=
github_password=
#github_user=


## internal variables
# tag_github_url=https://github.com/stan-dev/stan.git
tag_github_url=https://github.com/syclik/stan.git
# tag_github_api_url=https://api.github.com/repos/stan-dev/stan/pulls
tag_github_api_url=https://api.github.com/repos/syclik/stan
_msg=""
_steps[0]="Set up variables."
_steps[1]="Verify Stan is clean and up to date"
_steps[2]="Create release branch using git."
_steps[3]="Replace uses of old version number with new version number."
_steps[4]="Git add and commit changed files."
_steps[5]="Build documentation."
_steps[6]="Git add and commit build documentation."
_steps[7]="Test build. Git push."
_steps[8]="Create GitHub pull request."
_steps[9]="Merge GitHub pull request."
_steps[10]="Git tag version."
_steps[11]="Update master branch to new version"
_steps[12]="Create GitHub issue to remove documentation."
_steps[13]="Create git branch to remove documentation"
_steps[14]="Git remove and commit documentation"
_steps[15]="Git push branch to remove documentation."
_steps[16]="Create GitHub pull request to remove documentation."
_steps[17]="Merge GitHub pull request to remove documentation."

echo ""
echo "---------- Script to Stan ----------"
echo ""
echo "  Steps in this script:"
for ((n = 0; n < ${#_steps[@]}; n++))
do
  if [[ $n -lt 10 ]]; then
    echo "     "$n: ${_steps[$n]}
  else
    echo "    "$n: ${_steps[$n]}
  fi
done
echo ""

########################################
## 0: Set up variables
########################################
print_step 0
# _msg="Input Stan directory"
# if [[ -z $stan_directory ]]; then
#   read -p "  Input Stan directory: " stan_directory
# fi

# ## validate stan_directory
# _msg="Validating Stan directory: $stan_directory"
# if [[ ! -d $stan_directory ]]; then
#   _msg="Cloning Stan into $stan_directory"
#   eval "git clone $tag_github_url $stan_directory"
# fi

# pushd $stan_directory > /dev/null
# _msg="Verifying Stan in $stan_directory is correct"

# if [[ $(git ls-remote --get-url origin) != $tag_github_url ]]; then
#   _msg="Wrong repository!
#     $stan_directory is cloned from $(git ls-remote --get-url origin)
#     Expecting a clone of $tag_github_url"
#   exit 1
# fi
# popd > /dev/null

# ## reading old Stan version
# _msg="Reading old Stan version"
# if [[ -z $old_version ]]; then
#   tmp=$(read_major_version).$(read_minor_version).$(read_patch_version)
#   read -p "  Current Stan version (leave blank for: $tmp): " old_version
#   if [[ -z $old_version ]]; then
#     old_version=$tmp
#   fi
# fi

# _msg="Verifying old version matches the repository version"
# if ! check_version $old_version; then
#   _msg="Invalid old version: \"$old_version\""
#   exit 1
# fi
# if [[ $(read_major_version) -ne $(major_version $old_version) ]]; then
#   _msg="Invalid old version: \"$old_version\"
#     Expecting major version: $(read_major_version)"
#   exit 1
# fi
# if [[ $(read_minor_version) -ne $(minor_version $old_version) ]]; then
#   _msg="Invalid old version: \"$old_version\"
#     Expecting minor version: $(read_minor_version)"
#   exit 1
# fi
# if [[ $(read_patch_version) -ne $(patch_version $old_version) ]]; then
#   _msg="Invalid old version: \"$old_version\"
#     Expecting patch version: $(read_patch_version)"
#   exit 1
# fi

# ## reading new Stan version
# _msg="Reading new Stan version"
# if [[ -z $version ]]; then
#   read -p "  New Stan version (old version: $old_version): " version
# fi

# _msg="Verifying new Stan version"
# if ! check_version $version; then
#   _msg="Invalid new version: \"$version\""
#   exit 1
# fi
# if [[ $old_version == $version ]]; then
#   _msg="Invalid new version!
#     Trying to tag the same version: \"$version\""
#   exit 1
# fi

## read GitHub user name
_msg="Reading GitHub user name"
if [[ -z $github_user ]]; then
  read -p "  Github user name: " github_user
fi

## read GitHub user name
_msg="Reading Github password"
if [[ -z $github_password ]]; then
  read -s -p "  Github password (user: $github_user): " github_password
fi
echo

# ########################################
# ## 1. Verify $stan_home is clean and
# ##    up to date
# ########################################
# print_step 1
# _msg="Checking $stan_home"
# pushd $stan_directory > /dev/null

# if [[ -n $(git status --porcelain) ]]; then
#   _msg="$stan_home is not clean!
#     Verify the directory passes \"git status --porcelain\""
#   exit 1
# fi

# git checkout develop
# git pull --ff

# popd > /dev/null


# ########################################
# ## 2. Create release branch using git.
# ##    release/v$version
# ########################################
# print_step 2
# _msg="Creating release/v$version branch"
# pushd $stan_directory > /dev/null

# git checkout -b release/v$version

# popd > /dev/null


# ########################################
# ## 3. Update version numbers
# ########################################
# print_step 3
# _msg="Updating version numbers"
# pushd $stan_directory > /dev/null

# ## src/stan/version.hpp
# _msg="Updating version numbers: $stan_directory/src/stan/version.hpp"
# replace_major_version $version
# replace_minor_version $version
# replace_patch_version $version
# if [[ $(read_major_version) != $(major_version $version) \
#     || $(read_minor_version) != $(minor_version $version) \
#     || $(read_patch_version) != $(patch_version $version) ]]; then
#   _msg="Updating version numbers failed!
#     Check $stan_directory/src/stan/version.hpp"
#   exit 1
# fi

# replace_version $(grep -rlF --exclude={*.hpp,*.cpp} "$old_version" $stan_directory/src)

# popd > /dev/null


# ########################################
# ## 4. Git add and commit changed files
# ########################################
# print_step 4
# _msg="Committing changed files to local git repository"
# pushd $stan_directory > /dev/null


# git commit -m "release/v$version: updating version numbers" -a

# popd > /dev/null


# ########################################
# ## 5. Build documentation
# ########################################
# print_step 5
# _msg="Building documentation"
# pushd $stan_directory > /dev/null

# make manual doxygen > /dev/null

# popd > /dev/null


# ########################################
# ## 6. Git add and commit built documentation
# ########################################
# print_step 6
# _msg="Committing built documentation"
# pushd $stan_directory > /dev/null

# git add -f doc
# git commit -m "release/v$version: adding built documentation"

# popd > /dev/null


# ########################################
# ## 7. Final test. Git push
# ########################################
# print_step 7
# _msg="Pushing changes to github"
# pushd $stan_directory > /dev/null

# ### FIXME: Add testing code here
# git push origin release/v$version

# popd > /dev/null



########################################
## 8. Create github pull request
## FIXME!!
########################################
print_step 8
_msg="Create github pull request for $version"
pushd $stan_directory > /dev/null


create_pull_request "release/v$version" "release/v$version" "develop" "[skip ci]\n\n#### Summary:\n\nUpdates version numbers to v$version.\n\n#### Intended Effect:\n\nThe \`develop\` branch should be tagged as \`v$version\` after this is merged.\n\n#### How to Verify:\n\nInspect the code.\n\n#### Side Effects:\n\nNone.\n\n#### Documentation:\n\nDocumentation is included.\n\n#### Reviewer Suggestions: \n\nNone."

echo "PULL REQUEST NUMBER!!! " $pull_request_number


popd > /dev/null


########################################
## 9. 
## FIXME!!
########################################
# print_step 9
# _msg="Merging pull request"
# pushd $stan_directory > /dev/null


# merge_pull_request 10 "release/v$version"

# popd > /dev/null


########################################
## 10. 
## FIXME!!
########################################
print_step 10

########################################
## 11. 
## FIXME!!
########################################
print_step 11

########################################
## 12. 
## FIXME!!
########################################
print_step 12

########################################
## 13. 
## FIXME!!
########################################
print_step 13

########################################
## 14. 
## FIXME!!
########################################
print_step 14

########################################
## 15. 
## FIXME!!
########################################
print_step 15

########################################
## 16. 
## FIXME!!
########################################
print_step 16

########################################
## 17. 
## FIXME!!
########################################
print_step 17


trap : 0 

exit 0


