# Script de projet

*(petite définition avant toute chose : une autre aide parle de « scripter un projet ». Cela désigne tout le fonctionnement de ce Todoist Server qui permet de commander un projet pour ouvrir toutes les possibilités des tâches. Ici, on apprend à **créer un script de projet**, c’est-à-dire un fichier qui va exécuter une opération précise sur le projet, par exemple changer la version d’un manuscrit et l’ouvrir)*

Le script peut avoir n’importe quel langage et sera évalué dans le cadre du projet (à la racine du projet). Il peut servir à lancer un script ruby, par exemple : 

~~~bash
ruby ./citation.rb
~~~

---

### Emplacement du script

Un script doit obligatoirement être placé dans un dossier **`scripts`** à la racine du dossier du projet. Ce nom doit être absolument respecté (tout en minuscules, au pluriel).

Tous les scripts doivent rester à la racine de ce dossier, mais on peut créer des sous-dossier en les ajoutant au nom du script dans le [query-string][].

---

### Appeler un script depuis une tâche

Pour appeler, donc « jouer », un script depuis une tâche, il suffit de le mettre en nom en valeur du paramètre `script`. 

**Empreinte**

~~~bash
http://localhost:8000?p=<id projet>&script=<nom script>
~~~

**Exemple**

~~~bash
http://localhost:8000?p=quote&script=publish
~~~

> Ce script permet de publier automatiquement une citation sur un blog Substack.

---

### Script utilisant un alias rc

Si le script à jouer doit utiliser un alias défini dans le fichier `~/.zshrc` (ou autre fichier *rc*), il faut faire précéder la commande de : 

~~~bash
source ~/.zshrc && <code alias>
~~~

> Bien entendu, ci-dessus, il faut remplacer **`zshrc`** par le fichier utilisé sur votre système.

Par exemple, si vous utiliser VSCode comme ide, la commande `code` pour ouvrir un dossier dans VSCode à partir d’une commande bash est un `PATH` défini dans le fichier rc. Donc faire : 

~~~bash
source ~/.zshrc && code .
~~~

> Rappel : le point suffit ici puisque la commande est toujours exécuté dans le dossier du projet cible.



---

## Annexe



<a name="query-string"></a>

---

### Le query-string

Le « *query-string* » ou « *paramètres d’URL* » est la partie de l’URL après le point d’interrogation (« ? »), qui définit les paramètres dont aura besoin de le serveur pour exécuter une opération.

Par exemple :

~~~bash
http://localhost:8000?o=monprojet&ide=1
~~~

Ci-dessus, le *query-string* est **`o=monprojet&ide=1`**. Il définit deux paramètres, « o » et « ide » qui ont respectivement la valeur « monprojet » et « 1 ».



---



[query-string]: #query-string
