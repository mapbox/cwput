#!/usr/bin/env bash

failed="0"

TESTID="$(date '+%s')"
CMD="$(dirname $0)/../bin/cwput.bash"
export CWPUT_CONFIG_DIR="$(dirname $0)/../etc/checks"
export EC2_REGION="us-east-1"
export INSTANCE_ID="test-$TESTID"
export CWPUT_GROUP="testgroup-$TESTID"
export CWPUT_DIM_ID=${DIM_ID:-"[ {\"Name\": \"InstanceId\", \"Value\": \"$INSTANCE_ID\"} ]"}
export CWPUT_DIM_GROUP="[ {\"Name\": \"AutoScalingGroupName\", \"Value\": \"$CWPUT_GROUP\"} ]"
START_TIME="$(date -d '1 minute ago' -u --iso-8601=seconds)"

function assertExit0() {
    if $1 &> /tmp/test-output.log; then
        echo "ok - exit 0 $1";
    else
        echo "not ok - exit != 0 $1";
        cat /tmp/test-output.log
        failed="1"
    fi
}

# mocks docker client
export PATH=$(dirname $0):${PATH}

assertExit0 $CMD

echo "# waiting 60s for cloudwatch..."
sleep 60

END_TIME="$(date -d 'now' -u --iso-8601=seconds)"

for METRIC in ConnectionsTotal CPUUtilization rootDiskUtilization LoadAverage MemoryUtilization NetworkIn NetworkOut dockerDiskUtilization; do
    for DIM in "Name=InstanceId,Value=$INSTANCE_ID" "Name=AutoScalingGroupName,Value=$CWPUT_GROUP"; do
        if aws cloudwatch get-metric-statistics \
        --namespace="System/Linux" \
        --metric-name="$METRIC" \
        --dimensions="$DIM" \
        --start-time="$START_TIME" \
        --end-time="$END_TIME" \
        --statistics=SampleCount \
        --period=60 | grep SampleCount > /dev/null; then
            echo "ok - 1+ datapoints for $METRIC $DIM"
        else
            echo "not ok - 0 datapoints for $METRIC $DIM"
            failed="1"
        fi
    done
done

# Cleanup
if [ "$failed" == "1" ]; then
    exit 1
else
    exit 0
fi
