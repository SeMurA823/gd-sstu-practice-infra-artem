#!/bin/bash

# Edit ssh port 
sshPort='1274'
command="echo 'Port=${sshPort}' >> /etc/ssh/sshd_config"
echo $command
# new line
sudo sh -c "echo '' >> /etc/ssh/sshd_config"
# add "Port=${sshPort}" to end file "sshd_config"
sudo sh -c "${command}"
sudo /sbin/iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport $sshPort -j ACCEPT
sudo service sshd restart

# Download scripts for bastion-host
mkdir /home/ec2-user/bastion-scripts
aws s3 cp s3://191274-scripts-bucket/bastion-scripts/bastion-scripts.zip ./bastion-scripts.zip
sudo unzip -o ./bastion-scripts.zip -d /home/ec2-user/bastion-scripts
sudo chmod +x /home/ec2-user/bastion-scripts/ec2-connection.sh

