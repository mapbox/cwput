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

See ./etc/cwput/checks.  Use these example checks or remove them and
replace them with your own.  These example checks are installed during the
above installation step.
