#!/usr/bin/env bash

time=$(date +'%Y-%m-%d %H:%M')

JEKYLL_ENV=production bundle exec jekyll build
git add .
git commit -m "update($time)"
git push -u origin master