#!/bin/bash
FILES="bin level0* "
git add $FILES
git commit -m "auto commit by darodrig on `echo $(uname -n) | cut -d. -f1`"
git push origin main
