# Use the build-specific image
FROM frappe/build:version-15

ARG APPS_JSON_BASE64

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
