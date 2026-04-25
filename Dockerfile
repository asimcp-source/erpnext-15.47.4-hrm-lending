FROM frappe/build:version-15

ARG APPS_JSON_BASE64

# 1. Initialize the bench with ONLY Frappe first
RUN bench init /home/frappe/frappe-bench \
    --frappe-branch version-15 \
    --no-procfile \
    --no-backups \
    --skip-redis-config-generation \
    --skip-assets

# 2. Decode apps.json and install apps one by one
WORKDIR /home/frappe/frappe-bench
RUN if [ -n "${APPS_JSON_BASE64}" ]; then \
        echo "${APPS_JSON_BASE64}" | base64 -d > apps.json; \
        ./env/bin/python -m pip install --upgrade pip; \
        # This command tells bench to install the apps from the file
        bench get-app --from-json apps.json; \
    fi
