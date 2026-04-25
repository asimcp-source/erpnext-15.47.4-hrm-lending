# Use the official Frappe worker image for version 15
#FROM frappe/frappe-worker:v15
#FROM frappe/frappe-worker:version-15
FROM frappe/build:version-15

# This argument will be passed from your GitHub Action
ARG APPS_JSON_BASE64

# Install the apps listed in your apps.json
RUN export APP_INSTALL_ARGS="" && \
    if [ -n "${APPS_JSON_BASE64}" ]; then \
        export APP_INSTALL_ARGS="--apps-path=/opt/frappe/apps.json"; \
        echo "${APPS_JSON_BASE64}" | base64 -d > /opt/frappe/apps.json; \
    fi && \
    # The actual bench init process
    bench init ${APP_INSTALL_ARGS} \
    --frappe-branch=version-15 \
    --no-procfile \
    --no-backups \
    --skip-redis-config-generation \
    --verbose \
    /home/frappe/frappe-bench
