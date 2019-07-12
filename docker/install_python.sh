#!/usr/bin/env bash

apt-get update

if cat /etc/os-release | grep -q 16\.04; then
  # NVIDIA based containers run on 16.04 and don't include python3.6
  apt-get install -y software-properties-common
  add-apt-repository ppa:deadsnakes/ppa
  apt-get update
  apt-get -y install --no-install-recommends python3.6 python3.6-dev python3-pip python3-setuptools build-essential libssl-dev libffi-dev
  ln /usr/bin/python3.6 /usr/local/bin/python3
else
  # Modern Ubuntu images install more recent python versions.
  apt-get -y install --no-install-recommends python3 python3-pip python3-setuptools python3-dev build-essential libssl-dev libffi-dev
fi

apt-get clean
