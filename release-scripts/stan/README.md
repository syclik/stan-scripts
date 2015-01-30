# Stan Release Script

## Overview

Goals:
- tag new version of Stan quickly, easily, without error
- stop if Stan is broken, indicate error to user
- should be both interactive and non-interactive


Interactive will walk user through all steps.

Non-interactive will require the user to specify these variables.

### Variables
- `stan_home`: location of Stan. If empty dir, git clone.
- old version: match against version in src/stan/version.hpp
- version: replacement version


## Checklist

0. stan_home should have a clean git clone of stan. 
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
7. test! If passes, git push
8. github: merge pull request
9. git pull; git tag as v2.6.0
10. git update master to v2.6.0
11. create github issue to remove documentation; record number
11. git branch to feature/issue-#-remove-documentation
12. git remove built documentation; git commit
13. git push
14. create pull request
