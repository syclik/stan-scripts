#!/bin/bash

branch_tag() {
  echo '*** 1-branch.sh'
  pwd
  pushd $STAN_HOME
  git checkout -b release/v$TAG_VERSION
  popd
}
