#!/usr/bin/env bash

failed="0"

AWS_DEFAULT_REGION="us-east-1"
TESTID="$(date '+%s')"
CHECKS="$(dirname $0)/../etc/checks"
REGION="us-east-1"
INSTANCE="test-$TESTID"
CWPUT_GROUP="testgroup-$TESTID"
START_TIME="$(date -d '1 minute ago' -u --iso-8601=seconds)"

function assertExit0() {
    if $1 &> /dev/null; then
        echo "ok - exit 0 $1";
    else
        echo "not ok - exit 0 $1";
        failed="1"
    fi
}

assertExit0 "$CHECKS/connections $REGION $INSTANCE $CWPUT_GROUP"
assertExit0 "$CHECKS/cpu $REGION $INSTANCE $CWPUT_GROUP"
assertExit0 "$CHECKS/disk $REGION $INSTANCE $CWPUT_GROUP"
assertExit0 "$CHECKS/load $REGION $INSTANCE $CWPUT_GROUP"
assertExit0 "$CHECKS/memory $REGION $INSTANCE $CWPUT_GROUP"
assertExit0 "$CHECKS/networkin $REGION $INSTANCE $CWPUT_GROUP"
assertExit0 "$CHECKS/networkout $REGION $INSTANCE $CWPUT_GROUP"

echo "# waiting 60s for cloudwatch..."
sleep 60

END_TIME="$(date -d 'now' -u --iso-8601=seconds)"

for METRIC in ConnectionsTotal CPUUtilization rootDiskUtilization LoadAverage MemoryUtilization NetworkIn NetworkOut; do
    for DIM in "Name=InstanceId,Value=$INSTANCE" "Name=AutoScalingGroupName,Value=$CWPUT_GROUP"; do
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

