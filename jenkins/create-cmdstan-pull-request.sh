#!/bin/bash

trap 'abort' 0

set -e

########################################
## Functions
########################################

curl_success() {
  code=$(sed -n "s,.*HTTP/1.1 \([0-9]\{3\}\).*,\1,p" <<< "$1")
  [[ "$code" -eq "201" ]] || [ "$code" -eq "200" ]
}

parse_github_issue_number() {
  github_issue_number=$(sed -n "s,.*\"number\":[[:space:]]*\([0-9]*\).*,\1,p" <<< "$1")
}


########################################
## Echo
########################################


echo ""
echo "------------------------------------------------------------"
echo "  Stan Library's develop branch updated"
echo "  Creating a pull request on CmdStan to update its submodule"
echo ""

########################################
## Check to see if it's been updated
########################################

git checkout develop
git pull origin
make stan-revert
# pushd stan > /dev/null
# git checkout develop
# git pull origin
# make math-revert
# popd > /dev/null
# make stan-revert

original_commit_hash=$(cd stan && git rev-parse --short HEAD)
stan_commit_hash=$(cd stan && git rev-parse --short origin/develop)


if [ "$original_commit_hash" == "$stan_commit_hash" ]; then
  echo "------------------------------------------------------------"
  echo ""
  echo "  No need to create issue. "
  echo "  Submodule at: ${original_commit_hash}."
  echo "  Update to:    ${stan_commit_hash}."
  echo ""
  echo "------------------------------------------------------------"
  echo ""
  trap : 0 
  exit 0
fi

########################################
## Create GitHub issue
########################################

issue="{ 
  \"title\": \"Update submodule for the Stan Library\",
  \"body\":  \"The Stan Library develop branch has been updated.\nUpdate the submodule to ${stan_commit_hash}.\" }"

response=$(eval curl --include --user \"$github_user:$github_token\" --request POST --data \'$issue\' https://api.github.com/repos/stan-dev/cmdstan/issues)


if ! curl_success "${response}"; then
  _msg="
Error creating pull request:
----------------------------
$data


Response:
---------
$response
"
  exit 1
fi

parse_github_issue_number "${response}"


########################################
## Fix issue on a branch:
## - Create a git branch
## - Update the Stan Library to develop
## - Commit and push
########################################
git checkout -b feature/issue-${github_issue_number}-update-stan
pushd stan > /dev/null
git checkout ${stan_commit_hash}
popd > /dev/null
git commit -m "Fixes #${github_issue_number}. Updates the Stan submodule to ${stan_commit_hash}." stan
git push --set-upstream origin feature/issue-${github_issue_number}-update-stan

########################################
## Create pull request
########################################

pull_request="{
  \"title\": \"Update submodule for the Stan Library\",
  \"head\": \"feature/issue-${github_issue_number}-update-stan\",
  \"base\": \"develop\",
  \"body\": \"#### Summary:\n\nUpdates the Stan submodule to the current develop version, ${stan_commit_hash}.\n\n#### Intended Effect:\n\nThe Stan Library \`develop\` branch has been updated.\nThis pull request updates the submodule for the Stan Library submodule to ${stan_commit_hash}.\n\n#### Side Effects:\n\nNone.\n\n#### Documentation:\n\nNone.\n\n#### Reviewer Suggestions: \n\nNone.\" }"

response=$(eval curl --include --user \"$github_user:$github_token\" --request POST --data \'$pull_request\' https://api.github.com/repos/stan-dev/cmdstan/pulls)

if ! curl_success "${response}"; then
  _msg="
Error creating pull request
----------------------------
$data


Response:
---------
$response
"
  exit 1
fi
########################################
## Done
########################################

trap : 0 


echo "------------------------------------------------------------"
echo ""
echo "  Success creating a pull request updating submodule"
echo ""
echo "------------------------------------------------------------"
echo ""

exit 0


