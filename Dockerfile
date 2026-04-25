# Use the official Frappe builder image
FROM frappe/frappe-worker:v15.51.1

# This argument will be passed from your GitHub Action
ARG APPS_JSON_BASE64

# Install the apps listed in your apps.json
RUN export APP_INSTALL_ARGS="" && \
    if [ -n "${APPS_JSON_BASE64}" ]; then \
        export APP_INSTALL_ARGS="--apps_path=/opt/frappe/apps.json"; \
        echo "${APPS_JSON_BASE64}" | base64 -d > /opt/frappe/apps.json; \
    fi && \
    bench init ${APP_INSTALL_ARGS} \
    --frappe-branch=version-15 \
    --no-procfile \
    --no-backups \
    --skip-redis-config-generation \
    --verbose \
    /home/frappe/frappe-bench
