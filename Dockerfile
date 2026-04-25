FROM frappe/build:version-15

ARG APPS_JSON_BASE64

# Use /tmp for temporary files to avoid permission issues in /opt
RUN if [ -n "${APPS_JSON_BASE64}" ]; then \
        echo "${APPS_JSON_BASE64}" | base64 -d > /tmp/apps.json; \
    fi

# Create bench as the frappe user in their home directory
RUN bench init /home/frappe/frappe-bench \
    --frappe-branch version-15 \
    --apps_path /tmp/apps.json \
    --no-procfile \
    --no-backups \
    --skip-redis-config-generation \
    --verbose
