#!/bin/bash

echo "Début de la création de l'arborescence projet"

# 1. Création du répertoire projet avec ses sous-répertoires
echo "1. Création de l'arborescence de base..."
mkdir -p projet/docs projet/src projet/bin

# 2. Création du fichier manuel.txt dans docs
echo "2. Création du fichier manuel.txt..."
echo "Documentation du projet" > projet/docs/manuel.txt

# 3. Création des fichiers dans src
echo "3. Création des fichiers dans src/..."
echo '#!/bin/bash
echo "Programme principal"' > projet/src/main.sh

echo '#!/bin/bash
echo "Fonctions utilitaires"' > projet/src/utils.sh

# 4. Copie de main.sh dans bin sous le nom script.sh
echo "4. Copie de main.sh vers bin/script.sh..."
cp projet/src/main.sh projet/bin/script.sh

# 5. Déplacement de utils.sh dans docs
echo "5. Déplacement de utils.sh vers docs/..."
mv projet/src/utils.sh projet/docs/

# 6. Modification des permissions
echo "6. Modification des permissions..."
# main.sh et script.sh : lisibles et exécutables uniquement par le propriétaire (700)
chmod 700 projet/src/main.sh
chmod 700 projet/bin/script.sh

# manuel.txt : lisible par tous (644)
chmod 644 projet/docs/manuel.txt

# utils.sh maintenant dans docs
chmod 644 projet/docs/utils.sh

# 7. Changement du propriétaire pour tous les fichiers et répertoires
echo "7. Changement du propriétaire (9001:9001)..."
chown -R 9001:9001 projet/

# 8. Utilisation de find pour lister tous les fichiers .sh dans le répertoire projet
echo "8. Recherche des fichiers .sh..."
echo "Fichiers .sh dans le répertoire projet"
find projet/ -name "*.sh" -type f

# Vérification de l'arborescence finale
echo ""
echo "Arborescence finale"
tree projet/ 2>/dev/null || find projet/ -type d -exec echo "Répertoire: {}" \; -o -type f -exec echo "Fichier: {}" \;

echo ""
echo "Création terminée avec succès"