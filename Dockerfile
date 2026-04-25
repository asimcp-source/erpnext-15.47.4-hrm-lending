FROM frappe/build:version-15

ARG APPS_JSON_BASE64

# Decode the apps list
RUN if [ -n "${APPS_JSON_BASE64}" ]; then \
        echo "${APPS_JSON_BASE64}" | base64 -d > /tmp/apps.json; \
    fi

# Ensure we start in the correct directory and run bench init
# We remove any existing bench directory first to avoid 'directory not empty' errors
RUN rm -rf /home/frappe/frappe-bench && \
    bench init /home/frappe/frappe-bench \
    --frappe-branch version-15 \
    --apps_path /tmp/apps.json \
    --no-procfile \
    --no-backups \
    --skip-redis-config-generation \
    --verbose
