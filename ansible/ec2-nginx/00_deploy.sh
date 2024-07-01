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

if prompt "Update cache"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/1_install_nginx_certbot.yml" \
        --tags "update"
fi

if prompt "Install nginx"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/1_install_nginx_certbot.yml" \
        --tags "nginx"
fi

if prompt "Install certbot"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/1_install_nginx_certbot.yml" \
        --tags "certbot"
fi


if prompt "Copy site"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/1_install_nginx_certbot.yml" \
        --tags "oversecured"
fi

if prompt "Update nginx-http configuration"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/1_install_nginx_certbot.yml" \
        --tags "nginx-http"
fi

if prompt "Restart nginx"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/1_install_nginx_certbot.yml" \
        --tags "nginx-restart"
fi

