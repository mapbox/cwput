### 0.5.0

- Adds support for awscli 1.5.x.

### 0.4.0

- InstanceId value submitted to CloudWatch is now like
  $INSTANCEID-$STACK_NAME-$EC2_REGION which makes it easier to deal with
  aggregate and non-aggregate metrics within Librato.

### 0.3.0

- Use `AutoScalingGroupName` as the dimension when submitting metrics for an
  instance in an Autoscaling Group.  It is allowed to submit to an ASG that does
  not exist, in case a stack does not have an ASG.

### 0.2.0

- Adds handling for `CWPUT_GROUP` env var to provide value for 2nd metric dimension
- Drops requirement for `autoscaling:DescribeAutoScalingInstances` permission
