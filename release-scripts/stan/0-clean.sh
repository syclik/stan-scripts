#!/bin/bash

prerequisite() {
  echo '***** 0-clean.sh'
  echo '   STAN_HOME: ' $STAN_HOME
  pushd $STAN_HOME
  git clean -d -x -f
  git checkout develop
  git pull --ff
  popd
}
