- Docker ?

* un  outil qui permis de populariser la conteneurisation des applications. Il permet aux développeurs de créer, déployer et exécuter des applications dans des conteneurs légers et portables. Voici quelques concepts clés liés à Docker :
* - Conteneurs : Les conteneurs sont des environnements isolés qui contiennent tout ce dont une application a besoin pour fonctionner, y compris le code, les bibliothèques et les dépendances. Ils sont légers et démarrent rapidement.
* - Images : Une image Docker est un modèle en lecture seule utilisé pour créer des conteneurs. Elle contient le système de fichiers et les paramètres nécessaires pour exécuter une application.
* - Dockerfile : Un Dockerfile est un fichier texte qui contient une série d'instructions pour construire une image Docker. Il définit la base de l'image, les dépendances, les configurations et les commandes à exécuter.
* - Docker Hub : Docker Hub est un registre public où les utilisateurs peuvent stocker et partager des images Docker. Il permet de trouver des images préconstruites pour diverses applications et services.
* - Docker Compose : Docker Compose est un outil qui permet de définir et de gérer des applications multi-conteneurs. Il utilise un fichier YAML pour configurer les services, les réseaux et les volumes nécessaires à l'application.
* - Orchestration : Pour gérer des déploiements à grande échelle, des outils d'orchestration comme Kubernetes ou Docker Swarm sont utilisés pour automatiser le déploiement, la mise à l'échelle et la gestion des conteneurs.
* - Avantages : Docker offre plusieurs avantages, notamment la portabilité, la cohérence entre les environnements de développement et de production, l'efficacité des ressources et la facilité de déploiement.
* - Cas d'utilisation : Docker est largement utilisé pour le développement d'applications, les tests, l'intégration continue, le déploiement d'applications cloud-native et la microservices architecture.
* - Sécurité : Bien que les conteneurs offrent une isolation, il est important de suivre les meilleures pratiques de sécurité pour protéger les applications et les données.

en resumé, Docker est un outil puissant qui facilite la gestion des applications conteneurisées, offrant flexibilité, portabilité et efficacité aux développeurs et aux équipes DevOps.

- Comandes:

* **docker ps** : affiche les conteneurs en cours d'exécution.
* **docker run nginx:latest** : exécute un conteneur basé sur l'image Nginx.
* **docker ps -a**  : affiche tous les conteneurs, y compris ceux qui sont arrêtés.
* **docker ps -q** : affiche uniquement les IDs des conteneurs en cours d'exécution.
* **docker ps -q -a** : affiche  les IDs de tous les conteneurs.
* **docker run -d nginx:latest** : exécute un conteneur Nginx en arrière-plan (détaché).
* **docker run --name mynginx -d -p 8080:80 nginx:latest** : exécute un conteneur Nginx nommé "mynginx", en mappant le port 80 du conteneur au port 8080 de l'hôte.
* **docker run -ti ubuntu /bin/bash** : exécute un conteneur Ubuntu et ouvre une session interactive avec un shell bash.
* **docker stop <container_id>** : arrête un conteneur en cours d'exécution.
* **docker rm <container_id>** : supprime un conteneur arrêté.
* **docker rm -f <container_id>** : force la suppression d'un conteneur en cours d'exécution.
* **docker images** : affiche les images Docker disponibles localement.
* **docker rmi <image_id>** : supprime une image Docker.
* **docker pull <image_name>** : télécharge une image Docker depuis un registre (comme Docker Hub).
* **docker build -t myapp:latest .** : construit une image Docker à partir d'un Dockerfile dans le répertoire courant et la nomme "myapp" avec le tag "latest".
* **docker exec -it <container_id> /bin/bash** : ouvre une session interactive dans un conteneur en cours d'exécution.
* 
-Volumes:

* Les volumes Docker sont des mécanismes de stockage persistants utilisés pour conserver les données générées et utilisées par les conteneurs Docker. Contrairement aux systèmes de fichiers temporaires des conteneurs, 
* les volumes permettent de stocker des données de manière durable, même lorsque les conteneurs sont supprimés ou recréés. Voici quelques points clés sur les volumes Docker :
- Types de volumes : Il existe plusieurs types de volumes Docker, notamment les volumes gérés par Docker (volumes nommés), les montages de répertoires hôtes (bind mounts) et les volumes temporaires (tmpfs).
- Création de volumes : Les volumes peuvent être créés à l'aide de la commande `docker volume create <nom_du_volume>`. Ils peuvent également être créés automatiquement lors de l'exécution d'un conteneur avec l'option `-v` ou `--mount`.
- Montage de volumes : Les volumes peuvent être montés dans un conteneur en utilisant l'option `-v <nom_du_volume>:<chemin_dans_le_conteneur>` ou `--mount type=volume,source=<nom_du_volume>,target=<chemin_dans_le_conteneur>`.
- Persistance des données : Les volumes permettent de conserver les données même après la suppression du conteneur. Cela est particulièrement utile pour les bases de données et les applications nécessitant une conservation des données.

FROM node:20
# WORKDIR -Définir un répertoire de travail
WORKDIR /app
COPY package.json .
#RUN - Exécuter des commandes pendant la construction
RUN npm install
COPY app.js .
#EXPOSE - Documenter les ports (EXPOSE est juste informatif, il ne publie pas le port !)
EXPOSE 3001
CMD ["node", "/app/app.js"]


# Construire l'image
##docker build -t mon-premier-docker .
# Lancer le conteneur
##docker run mon-premier-docker

#RUN = s'exécute pendant docker build
#CMD = s'exécute pendant docker run

####################Optimisation Simple#####################£
####Comprendre le caching des couches Docker###
#docker met en cahce chaque instruction.si rein n'a changé ,il réuitilise le cache

#Mauvais Exemple (lent)
FROM node:20
WORKDIR /app
# Si un fichier change, tout se refait
COPY . .
# npm install se refait à chaque fois !
RUN npm install
CMD ["node", "app.js"]

#Bon Exemple (rapide)
FROM node:20
WORKDIR /app
# Copie juste les dépendances
COPY package.json .
# Cache tant que package.json ne change pas
RUN npm install
# Copie le reste après
COPY . .
CMD ["node", "app.js"]

#copie just dependadnce(package.json) ->cache en tant que package ne chn age pas -> copy le reste apres
#---------------------------------------------------------------------------
#ENV - Variables d'environnement
WORKDIR /app
# Définir des variables
ENV NODE_ENV=production
ENV PORT=3000

COPY package.json .
RUN npm install
COPY . .

EXPOSE ${PORT}
CMD ["node", "app.js"]