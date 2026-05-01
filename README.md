# Todoist-Server

(Mac-only)

Serveur pour l'application Todosit, qui permet d'exécuter n'importe quelles opérations à partir d'une simple tâche Todoist.

Par exemple, en cliquant sur un lien « **Commencer le travail** » dans Todoist, on peut :

* afficher le dossier du projet dans le Finder,
* passer le fichier principal à un numéro de patch supérieur,
* lancer un minuteur du temps voulu,
* afficher les choses à faire sur le projet,
* passer l'ordinateur en mode sombre,
* paser l'ordinateur en mode « Ne pas déranger ».

Oui, à partir d'un simple clic sur la tâche !

### Warning

Cette application est encore à l'état de développement, elle fonctionne parfaitement mais l'installation n'est pas encore optimisée.

Dans sa version simple, qui fonctionne avec votre navigateur par défaut, il suffit de jouer :

~~~bash
python3 /Users/<vous>/<path/to>/Todoist-server/server.py
~~~

Mais le plus puissant sera de créer une application web appelée par [Velja](https://sindresorhus.com/velja) lorsque l'url **`http://localhost:8000`** est invoquée (todo: opération à détailler).