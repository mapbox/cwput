## cwput

Very simple script to send custom metrics to AWS CloudWatch

## Requirements

- aws-cli
- upstart, systemd or launchd
- AWS API permissions
  - cloudwatch:PutMetricData
- For OSX installs, coreutils must be installed from brew

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

#### CWPUT_DISABLE_DETAILED

Set `CWPUT_DISABLE_DETAILED` to `true` if you want to send metrics to the
CloudWatch API every 5 minutes instead of every 1 minute.  For example, if your
EC2 is not using CloudWatch detailed monitoring, you could instead send
CloudWatch metrics every 5 minutes by setting this variable, which will reduce
the number of API calls made to CloudWatch.
