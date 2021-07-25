#!/bin/bash
sudo apt update

# Download scripts for instance and unzip
aws s3 cp s3://191274-scripts-bucket/instance-scripts/instance-scripts.zip ./instance-scripts.zip
sudo apt -y install unzip
sudo mkdir /home/ubuntu/instance-scripts
sudo unzip -o ./instance-scripts.zip -d /home/ubuntu/instance-scripts
sudo chmod +x /home/ubuntu/instance-scripts/deploy.sh

# Logging
wget https://s3.us-east-1.amazonaws.com/amazoncloudwatch-agent-us-east-1/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
sudo mkdir -p /usr/share/collectd/
sudo touch /usr/share/collectd/types.db
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/home/ubuntu/instance-scripts/config.json

# Install python modules
sudo apt -y install pip
pip3 install -r /home/ubuntu/instance-scripts/requirements.txt

# Get latest tag and deploy
latestTag=$(python3 /home/ubuntu/instance-scripts/latestTag.py)
/home/ubuntu/instance-scripts/deploy.sh $latestTag
