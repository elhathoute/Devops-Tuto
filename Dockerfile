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