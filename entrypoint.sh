#!/bin/sh

# Exécute le script d'entrypoint d'Odoo en arrière-plan
/entrypoint.sh &

# Attendre qu'Odoo soit prêt (exemple basique en utilisant netcat)
echo "Attente du démarrage d'Odoo..."
while ! nc -z localhost 8069; do
  sleep 1
done
echo "Odoo est démarré."

# Exécuter les tests
# Assurez-vous que le nom du conteneur est correct ou passé en paramètre si variable
docker exec odoo-test /opt/odoo/odoo-bin -c /etc/odoo/odoo.conf --test-enable --stop-after-init

# Garder le conteneur en cours d'exécution si nécessaire
# tail -f /dev/null

