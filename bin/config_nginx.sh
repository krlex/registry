#!/bin/bash

# Load variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Escape variables that should not be replaced
ESCAPED_TEMPLATE=$(sed 's/\$http_host/__HTTP_HOST__/g; s/\$remote_addr/__REMOTE_ADDR__/g' ./nginx/config.conf.template)

# Use envsubst to replace variables in the template
echo "$ESCAPED_TEMPLATE" | envsubst > /etc/nginx/conf.d/registry.${REGISTRY_DOMAIN}.conf

# Unescape the variables that should not be replaced
sed -i 's/__HTTP_HOST__/\$http_host/g; s/__REMOTE_ADDR__/\$remote_addr/g' /etc/nginx/conf.d/registry.${REGISTRY_DOMAIN}.conf

# Optionally, reload Nginx to apply the new configuration
sudo systemctl reload nginx
