FROM frappe/build:version-15

ARG APPS_JSON_BASE64

# Initialize bench
RUN bench init /home/frappe/frappe-bench \
    --frappe-branch version-15 \
    --no-procfile \
    --no-backups \
    --skip-redis-config-generation \
    --skip-assets

WORKDIR /home/frappe/frappe-bench

# Install apps with resolution flags
RUN if [ -n "${APPS_JSON_BASE64}" ]; then \
        echo "${APPS_JSON_BASE64}" | base64 -d > apps.json; \
        # We add --resolve-deps to fix version conflicts between ERPNext and HRMS
        python3 -c "import json; [print(f'bench get-app {a[\"url\"]} --branch {a[\"branch\"]} --resolve-deps') for a in json.load(open('apps.json'))]" | bash; \
    fi
