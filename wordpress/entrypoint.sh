#!/bin/bash
set -e

# Ajout dans wp-config.php si ce n'est pas déjà fait
WP_CONFIG=/var/www/html/wp-config.php

if [ -f "$WP_CONFIG" ] && ! grep -q "HTTP_X_FORWARDED_PROTO" "$WP_CONFIG"; then
  echo "Ajout du support HTTPS derrière proxy dans wp-config.php"
  cat << 'EOL' >> "$WP_CONFIG"

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}
EOL
fi

# Lancer le point d’entrée officiel
exec docker-entrypoint.sh apache2-foreground

