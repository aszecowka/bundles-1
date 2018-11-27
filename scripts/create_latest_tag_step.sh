#!/usr/bin/env bash

GIT_URL=$1

git config --global user.email "prow@kyma.cx"
git config --global user.name "Prow CI"
export GIT_TAG=latest
git tag $GIT_TAG -f -a -m "Generated tag from ProwCI"
git push ${GIT_URL} $GIT_TAG -f