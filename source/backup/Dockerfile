FROM alpine:latest

# Install S3 client
RUN apk add --no-cache python3 py-pip py-setuptools git ca-certificates

RUN pip install python-magic \
  && git clone https://github.com/s3tools/s3cmd.git /tmp/s3cmd \
  && cd /tmp/s3cmd \
  && python3 /tmp/s3cmd/setup.py install \
  && cd / \
  && rm -rf /tmp/s3cmd \
  && apk del py-pip git


# Install mongodump command
RUN apk add --no-cache mongodb-tools

# Copy and run backup script
WORKDIR /root
COPY /script /root
