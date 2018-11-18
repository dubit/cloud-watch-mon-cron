AWS_MON_PUT='/opt/cloud-watch-mon/scripts/mon-put-instance-data.pl'

echo "Running AWS monitor script"

params=${MONITOR_ARGUMENTS:="--mem-util --disk-space-util --disk-path=/"}

# Pass through any variables that the user has specified
$AWS_MON_PUT \
    $(if [ ! -z $AWS_ACCESS_KEY ]; then echo "--aws-access-key-id=${AWS_ACCESS_KEY}"; else echo ""; fi) \
    $(if [ ! -z $AWS_SECRET_KEY ]; then echo "--aws-secret-key=${AWS_SECRET_KEY}"; else echo ""; fi) \
    $params