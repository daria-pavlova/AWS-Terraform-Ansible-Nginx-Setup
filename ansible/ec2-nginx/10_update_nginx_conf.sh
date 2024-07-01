if [[ "${DEBUG:-false}" = true ]]; then
    set -x
fi

set -euo pipefail

this="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ENVIRONMENT="dev"
INVENTORY_FILE="$this/inventory$ENVIRONMENT.ini"
prompt() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

echo "Base directory: $this"
echo "Environment: $ENVIRONMENT"

if prompt "Copy site"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/2_update_nginx_conf.yaml" \
        --tags "dog-facts"
fi

if prompt "Update nginx-http configuration"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/2_update_nginx_conf.yaml" \
        --tags "nginx-http"
fi


if prompt "Configure https certificate"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/2_update_nginx_conf.yaml" \
        --tags "certbot-create"
fi

if prompt "Update nginx-https configuration"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/2_update_nginx_conf.yaml" \
        --tags "nginx-https"
fi

if prompt "Restart nginx"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/2_update_nginx_conf.yaml" \
        --tags "nginx-restart"
fi


