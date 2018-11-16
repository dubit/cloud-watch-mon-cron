# Cloud Watch Monitor Script Docker image
### `dubit/cloud-watch-mon-cron`

Amazon's Cloud Watch monitoring scripts as a cron task in a container.

This image wraps [Amazon's cloud watch monitoring scripts](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html) and runs the put instance data script on a schedule using cron.

This means the scripts can be deployed into your container ecosystem in a consistent way, without having to configure the hosts just to get hard disk and memory metrics.

The version of the monitoring scripts is `1.2.2`

## How to use the image:

This image needs an IAM user with valid permissions in order to run, by default the cron task will run every 5 minutes
and will send the following metrics:

- Memory utilized in percentages
- Memory that is cached and in buffers as used
- Disk space utilized in percentages

> `docker run dubit/cloud-watch-mon-cron -e AWS_ACCESS_KEY='xxxxxxxx' -e AWS_SECRET_KEY='xxxxxxx'`

AWS credentials can also be specified in a file, which will need voluming in (note this is due to how the script works not the image, see Amazon's help page for more info)

**awscreds.conf**

```
    AWSAccessKeyId = my-access-key-id
    AWSSecretKey = my-secret-access-key
```

> `docker run dubit/cloud-watch-mon-cron -v 'awscreds.conf:/opt/scripts/awscreds.conf'`

### Changing the CRON schedule

The cron schedule can be changed using the env var `CRON_SCHEDULE` this value is substitued into the crontab file when the container is booted. The default is every 5 minutes

For example to run the script once a day:
> `docker run dubit/cloud-watch-mon-cron -e CRON_SCHEDULE='0 0 * * *' -e AWS_SEC...`

### Script arguments

Amazon's perl scripts can be configured with command line arguments, for ease of use the default arguments run with the `mon-put-instance-data.pl` script are `--mem-used-incl-cache-buff --mem-util --disk-space-util --disk-path=/`

The arguments can be overriden by specifiying them in the `MONITOR_ARGUMENTS` env var.

For example to test what the script will output from the mem util, with increased verbosity:
> `docker run dubit/cloud-watch-mon-cron -e MONITOR_ARGUMENTS='--mem-util --verify --verbose' -e AWS_SEC...`

## Link to DockerHub:

You can find this image on Dubit's Docker Hub: <https://hub.docker.com/r/dubit/cloud-watch-mon-cron/>
