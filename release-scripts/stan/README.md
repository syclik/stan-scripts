# Stan Release Script

## Overview

Want a release script that will update the version number of Stan.

## Define:
The new version number.
The location of Stan.

## Checklist

0. all tests pass; clean state of git (git clean -d -x -f)
1. git branch to release/v2.6.0
2. replace uses of old version number (v2.5.0) and replace with new version number (v2.6.0)
  - src/stan/version.hpp
  - src/docs/stan-reference/programming.tex
  - src/docs/stan-reference/stan-reference.tex
  - src/doxygen/doxygen.cfg
3. git add changed files
4. build documentation
  - doc/stan*.pdf
5. git add built documentation
6. git commit to branch
7. git push
8. github: merge pull request
9. git pull; git tag as v2.6.0
10. git update master to v2.6.0
11. create github issue to remove documentation; record number
11. git branch to feature/issue-#-remove-documentation
12. git remove built documentation; git commit
13. git push
14. create pull request
