#!/bin/bash

tag=$1

ip_start_list=$(aws ec2 describe-instances --region us-east-1 --filter Name="tag:aws:autoscaling:groupName",Values="petclinic" Name="instance-state-name",Values="running" --no-paginate --query 'Reservations[*].Instances[*].NetworkInterfaces[*].PrivateIpAddresses[*].PrivateIpAddress' --output text)


for ip in $ip_start_list
do
        ssh -o StrictHostKeyChecking=no ubuntu@$ip /home/ubuntu/instance-scripts/deploy.sh $tag
        code=$?
        if [[ "$code" != 0 ]] && [[ "$code" != 255 ]]; then
                exit $code
        fi
done
