#!/usr/bin/env bash

CONFIG_DIR="/etc/cwput/checks"
INSTANCEID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed '$s/.$//')
ASGNAME=$(aws autoscaling describe-auto-scaling-instances --region $REGION --output text --instance-ids $INSTANCEID --query 'AutoScalingInstances[0].AutoScalingGroupName')

if [ -z $INSTANCEID ]; then
    echo "InstanceID could not be determined"
    exit 1
fi

if [ -z $REGION ]; then
    echo "Region could not be determined"
    exit 1
fi

if [ -z $ASGNAME ]; then
    echo "Autoscaling Group Name could not be determined"
    exit 1
fi

for file in $( ls $CONFIG_DIR );
do
    # timeout to avoid overlapping jobs in case of slow command
    timeout 30 $CONFIG_DIR/$file $REGION $INSTANCEID $ASGNAME &
    # Reduce load on instance and CloudWatch API request rate
    sleep $[ ( $RANDOM % 6 )  + 1 ]
done
