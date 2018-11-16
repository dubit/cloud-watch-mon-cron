FROM alpine:3.8

# Install perl to run the aws scripts
RUN apk add perl && \
    apk add perl-libwww && \
    apk add perl-lwp-protocol-https && \
    apk add perl-datetime

# Install envsubst
RUN apk add --update libintl && \
    apk add --virtual build_deps gettext &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

# Copy the AWS Perl scripts
COPY ./scripts  /opt/cloud-watch-mon/scripts

# Copy the Cron template which has an ENV var in which will be replaced using envsubst
COPY ./crontemplate /opt/cloud-watch-mon/crontemplate

RUN chmod 0644 /opt/cloud-watch-mon/crontemplate

# Copy across the script used in the cron task
COPY ./aws-mon.sh /opt/cloud-watch-mon/aws-mon.sh

# Set a default  of "every 5 minutes" for the env var
# CRON_SCHEDULE replaces the value in the crontemplate using envsubst at runtime
ENV CRON_SCHEDULE '*/5 * * * *'

CMD /bin/sh -c "envsubst < /opt/cloud-watch-mon/crontemplate > /etc/crontabs/root && crond -f"