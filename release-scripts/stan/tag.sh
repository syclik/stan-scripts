#!/bin/bash

. 0-clean.sh
. 1-branch.sh
. 2-update.sh

## variable declaration: need to set from the outside
STAN_HOME=~/dev/stan
OLD_VERSION=2.5.0
OLD_VERSION_MAJOR=2
OLD_VERSION_MINOR=5
OLD_VERSION_PATCH=0
TAG_VERSION=2.6.0
TAG_VERSION_MAJOR=2
TAG_VERSION_MINOR=6
TAG_VERSION_PATCH=0

echo '--- tag script ---'
# prerequisite  # 0-clean.sh
# branch_tag    # 1-branch.sh
update       # 2-update.sh
