ARG BLACKBOX_EXPORTER_VERSION=v0.26.0

# Use the official blackbox-exporter image
FROM prom/blackbox-exporter:${BLACKBOX_EXPORTER_VERSION}

# Switch to root to install curl
USER root

# Install curl. The --no-cache flag is used to reduce image size.
RUN apk update && apk add --no-cache curl

# Switch back to the non-root user for security
USER nobody