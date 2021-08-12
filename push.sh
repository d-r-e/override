#!/bin/bash

git add .
git commit -m "auto commit by darodrig on `echo $(uname -n)`"
git push origin main
