# Lancement du serveur

Pour lancer le serveur — qui se lance normalement au démarrage de l’ordinateur —, il faut double-cliquer sur le fichier `Todoist-Server.app` qui est une mini-app lançant le serveur python défini dans `server.py`.

Le serveur utilise le port 8000 défini dans `server.py`. Noter que si ce port doit être changé, il faut aussi le changer à différent endroit du projet. Ouvrir le dossier `programmes/Todoist-server` et faire une recherche sur le numéro de port actuel.

### Arrêt et relance du serveur

Après modification du fichier `handler.rb` ou autre fichier mis en cache, il est nécessaire de relancer le serveur.

~~~
kill $(lsof -ti :8000); sleep 0.5; python3 /Users/philippeperret/Programmes/Todoist-server/server.py &
~~~

> Changer le port si nécessaire.
