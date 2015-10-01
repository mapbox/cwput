## cwput

Very simple script to send custom metrics to AWS CloudWatch

## Requirements

- aws-cli
- upstart
- AWS API permissions
  - cloudwatch:PutMetricData

## Install

`./install.bash`

## Configure

### Add or remove checks

See ./etc/cwput/checks.  Use these example checks or remove them and
replace them with your own.  These example checks are installed during the
above installation step.

### Settings

#### CWPUT_GROUP

Set the `CWPUT_GROUP` environment variable to define a second dimension for
grouping together metrics. For example, by setting `CWPUT_GROUP` to the
autoscaling group ID of instances metrics can be tracked both by individual
instance IDs and by the AS group as a whole.

If unset the second dimension will fallback to the instance ID.

#### CWPUT_NAMESPACE

Set the `CWPUT_NAMESPACE` environment variable to submit metrics to CloudWatch
using a namespace different from the cwput default of `System/Linux`

#### CWPUT_PERIOD

The number of minutes between metric reporting. Expected values are `0`, `1` &
`5`.  Setting `CWPUT_PERIOD` to other values will result in undefined behavior.
Setting a value of `0` will disable reporting. Default is `1`.
