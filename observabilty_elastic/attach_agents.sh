#!/bin/bash
URL=$1
TOKEN=$2
echo $URL
echo $TOKEN
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.9.2-linux-x86_64.tar.gz
sudo tar xzvf elastic-agent-8.9.2-linux-x86_64.tar.gz 
cd /elastic-agent-8.9.2-linux-x86_64/data/elastic-agent-162ea9/
sudo ./elastic-agent install -n --url=$URL --enrollment-token=$TOKEN

