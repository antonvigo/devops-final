#!/bin/bash

curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent4.sh | sh
/opt/td-agent/bin/fluent-gem install fluent-plugin-gelf
