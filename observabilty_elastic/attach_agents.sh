#!/bin/bash
URL=$1
TOKEN=$2

curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.9.2-linux-x86_64.tar.gz
sudo cd /tmp/
sudo tar xzvf elastic-agent-8.9.2-linux-x86_64.tar.gz
sudo cd elastic-agent-8.9.2-linux-x86_64
sudo ./elastic-agent install --url=$URL --enrollment-token=$TOKEN
