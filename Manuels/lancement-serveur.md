## TodoistServeur

Ce terme recouvre deux choses :

* l’application `Todoist-Server.app` qui lance le serveur python,
* l’application web Safari (Safari Web App) qui reçoit `localhost:8000` (par Velja)

## Lancement du serveur

Pour lancer le serveur — qui se lance normalement au démarrage de l’ordinateur —, il faut double-cliquer sur le fichier `Todoist-Server.app` qui est une mini-app lançant le serveur python défini dans `server.py`.

Le serveur utilise le port 8000 défini dans `server.py`. Noter que si ce port doit être changé, il faut aussi le changer à différent endroit du projet. Ouvrir le dossier `programmes/Todoist-server` et faire une recherche sur le numéro de port actuel.

### Arrêt et relance du serveur

Après modification du fichier `handler.rb` ou autre fichier mis en cache, il est nécessaire de relancer le serveur.

~~~
kill $(lsof -ti :8000); sleep 0.5; python3 /Users/philippeperret/Programmes/Todoist-server/server.py &
~~~

> Changer le port si nécessaire.

## Contenu des pages et messages

On ne peut pas ouvrir de « console web » pour TodoistServer (la SWA). Mais on peut l’obtenir sans Safari lui-même, dans le menu `Développement > <mon disque> > `

> Demander l’affichage du menu Développement dans Safari le cas échéant.
