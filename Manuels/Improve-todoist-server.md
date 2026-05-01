# Améliorer Todoist-Server

*Ceci est l’aide pour développer le scriptage de tâche et de projet que permet todoist-server.*

Tout le traitement se fait dans le fichier `handler.rb` qui reçoit la requête client venant de Todoist.

Pour le modifier confortablement, ouvrir le dossier [Todoist-server](/Users/philippeperret/Programmes/Todoist-server) dans VSCode ou autre éditeur de code.

On peut recevoir n’importe quel paramètre et valeur par le biais du *query-string*. Pour le moment sont définis :

| PARAMÈTRE | VALEUR                                                       | NOTE |
| --------- | ------------------------------------------------------------ | ---- |
| **`p`**   | Pour définir le projet concerné par la commande. Note : c’est un identifiant qui doit être être défini dans `PROJETS.yaml`. |      |
| **`o`**   | Pour ouvrir dans le Finder le projet qui a pour identifiant la valeur de `o`.<br />`http://localhost:8000?o=digest` |      |
| **`f`**   | Pour définir n’importe quel fichier ou dossier à ouvrir par le Finder. Si c’est un fichier, son extension doit définir l’application à utiliser. |      |
| **`d`**   | Pour ouvrir le fichier de données du projet.<br />`http://localhost:8000?d=digest` |      |
|           |                                                              |      |



### Forcer l’arrêt du serveur et le relancer

~~~
> kill $(lsof -ti :8000); sleep 0.5; python3 /Users/philippeperret/Programmes/Todoist-server/server.py &  
~~~

