#!/bin/bash

set -e

ami_id=$(cat output.json | jq '.builds[] | .artifact_id' | cut -f2 -d: | tr -d '"')
echo "Finding the snapshots associated for ${ami_id}"

snapshot_ids=$(aws ec2 describe-images --image-id $ami_id --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' --output text)

echo -e "Snapshots associated with the AMI ${ami_id}\n${snapshot_ids}"

echo "Deregistering the AMI ${ami_id}"

aws ec2 deregister-image --image-id ${ami_id}

echo "Removed AMI ${ami_id}"

for snapshot_id in $snapshot_ids; do
    aws ec2 delete-snapshot --snapshot-id $snapshot_id
    echo "Removed snapshot ${snapshot_id}"
done
