FROM alpine:3.19 AS builder

# Install curl with HTTP/3 support.
# The default curl package in Alpine 3.19 should be sufficient.
RUN apk update && apk add --no-cache curl

# Use the official blackbox-exporter image
ARG BLACKBOX_EXPORTER_VERSION
FROM prom/blackbox-exporter:${BLACKBOX_EXPORTER_VERSION}

# Copy the curl binary from the builder stage
COPY --from=builder /usr/bin/curl /usr/bin/curl

# The base image already sets the user to 'nobody', but we are explicit.
USER nobody