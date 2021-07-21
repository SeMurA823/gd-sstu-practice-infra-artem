#!/bin/bash

#function deploy {
#    sudo docker stop petclinic-container
#    sudo docker rm petclinic-container
#    sudo docker rmi $(sudo docker images -q 050376771752.dkr.ecr.us-east-1.amazonaws.com/ecr-repo)
#    aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 050376771752.dkr.ecr.us-east-1.amazonaws.com
#    latestTag=$(aws ecr list-images --repository-name ecr-repo --query 'imageIds[*].imageTag' --output text --region us-east-1 | python3 latestTag.py)
#    sudo docker run --name petclinic-container -p 8080:8080 -d 050376771752.dkr.ecr.us-east-1.amazonaws.com/ecr-repo:$latestTag
#    controlTag=$(aws ecr list-images --repository-name ecr-repo --query 'imageIds[*].imageTag' --output text --region us-east-1 | python3 latestTag.py)
#    if ! [[ $latestTag == $controlTag ]]; then
#        deploy
#    fi
#}

# Download scripts for instance and unzip
aws s3 cp s3://191274-scripts-bucket/instance-scripts/instance-scripts.zip ./instance-scripts.zip
sudo apt -y install unzip
sudo mkdir /home/ubuntu/instance-scripts
sudo unzip -o ./instance-scripts.zip -d /home/ubuntu/instance-scripts
sudo chmod +x /home/ubuntu/instance-scripts/deploy.sh

# Install python modules
sudo apt -y install pip
pip3 install -r /home/ubuntu/instance-scripts/requirements.txt

# Get latest tag and deploy
latestTag=$(python3 /home/ubuntu/instance-scripts/latestTag.py)
/home/ubuntu/instance-scripts/deploy.sh $latestTag


