## cwput

Very simple script to send custom metrics to AWS CloudWatch

## Requirements

- aws-cli
- upstart
- AWS API permissions
  - cloudwatch:PutMetricData
  - autoscaling:DescribeAutoScalingInstances

## Install

`sudo make`

## Configure

Put bash scripts in /etc/cwput/checks and cwput will execute them. For example:

```shell
#!/usr/bin/env bash

REGION=$1
NAMESPACE="System/Linux"
METRIC_NAME="MemoryPercentUsed"
DIMENSIONS="InstanceId=$2"
ASDIMENSIONS="AutoScalingGroupName=$3"
UNIT="Percent"

TOTAL=$(free -m | grep "Mem" | tr -s " " | cut -d " " -f 2)
FREE=$(free -m | grep "buffers/cache" | tr -s " " | cut -d " " -f 4)
VALUE=$((100 - (( (($FREE * 100)) / $TOTAL)) ))

aws cloudwatch put-metric-data \
    --region $REGION \
    --namespace $NAMESPACE \
    --metric-name $METRIC_NAME \
    --dimensions $DIMENSIONS \
    --value $VALUE \
    --unit $UNIT

aws cloudwatch put-metric-data \
    --region $REGION \
    --namespace $NAMESPACE \
    --metric-name $METRIC_NAME \
    --dimensions $ASDIMENSIONS \
    --value $VALUE \
    --unit $UNIT
```
