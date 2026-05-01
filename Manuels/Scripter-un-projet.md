# Scripter un projet

*« scripter un projet » signifie exécuter n’importe quelle opération informatique de la plus simple à le plus complexe **à partir d’un simple lien dans une tâche todoist** (qu’on désigne par « [appel serveur depuis la tâche](#server-call) ci-dessous).*

On peut par exemple, **d’un simple clic sur une tâche** :

* ouvrir le dossier du projet dans le Finder,
* faire une nouvelle version du fichier principal,
* lancer un minuteur de 2 heures,
* afficher les tâches à exécuter aujourd’hui,
* mettre l’ordinateur en mode « ne pas déranger »,
* mettre l’ordinateur en mode sombre.

La magie est possible grâce au ***serveur-todoist*** que j’ai implémenté et qui tourne en permanence comme une application web attendant une URL (qui, ici, définit la commande). Ce serveur local reçoit la requête de Todoist, la transmet à `handler.rb` qui effectue n’importe quelle opération.

[TOC]



<a name="server-call"></a>

---

## Appel serveur depuis la tâche

### Définition de l’appel serveur

Pour exécuter cette opération quelconque, on fait ce qu’on appelle un *appel serveur* à l’intérieur même de la tâche.

Un appel server est une URL (aka une adresse web) qui commence par **`http://localhost:8000`** et est suivi par les paramètres de l’appel, par exemple pour ouvrir un projet les paramètres **`o=id_projet`**. 

Les deux sont assemblés avec un **`?`** ce qui permet d’obtenir : 

~~~bash
# Exemple complet d'appel serveur
http://localhost:8000?o=idprojet
~~~

### Utiliser l’appel serveur dans la tâche Todoist

* Créer la tâche dans Todoist,
* mettre par exemple en texte « OUVRIR LE PROJET »,
* sélectionner ce texte,
* dans le menu contextuel qui s’ouvre, choisir « Lien » (ou équivalent),
* taper dans le champ qui s’affiche l’appel voulu.

---

## Liste résumé des opérations de base

> On appelle « opérations de base » les oprations qui sont exécutables avec en général un seul paramètre en [query-string][] en plus de l’identifiant du projet.



| PARAMÈTRE    | Explication                                                  | VALEUR                                           |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------ |
| **`p`**      | Définit pour la commande le projet visé. Note : c’est un identifiant qui doit être être défini dans `PROJETS.yaml`. Par exemple : <br />`http://localhost:8000?p=digest&script=publish` |                                                  |
| **`o`**      | Pour ouvrir dans le Finder le projet qui a pour identifiant la valeur de `o`.<br />`http://localhost:8000?o=digest`<br />Ajouter le paramètre **`mode`** avec comme valeur `ide` si vous voulez ouvrir le projet dans VSCode (si c’est un projet informatique par exemple. | [ID du projet][]                                 |
|              |                                                              |                                                  |
| **`f`**      | Pour définir n’importe quel fichier ou dossier à ouvrir par le Finder. Si c’est un fichier, son extension doit définir l’application à utiliser. | Chemin absolu du fichier (sans espaces)          |
| **`d`**      | Pour ouvrir le fichier de données du projet.<br />`http://localhost:8000?d=digest` | [ID du projet][]                                 |
| **`script`** | Pour jouer un script défini par le projet ou un script universel (connu du serveur). Pour le détail, voir le fichier [Script de projet](./Project_Script.pdf). | Nom racine (ie sans extension) du script à jouer |



---



## Description des opérations

### Lancer un minuteur sur le projet

À partir d’une tâche, on peut lancer un minuteur sympa qui va décompter le temps à faire et l’enregistrer ensuite dans le fichier des données du projet. Pour ce faire, il suffit d’ajouter dans une tâche le lien : 

~~~
http://localhost:8000?t=<nombre minutes>&p=<id projet>
~~~

> **`t`** pour *time*
> **`p`** pour *projet* (voir [ci-dessous](#) pour savoir comment définir le projet.)

Par exemple : **`http://localhost:8000?t=120&p=parc`** (pour travailler 2 heures sur le parc).

{TODO: Ajouter à l’horloge affichée, dans la fenêtre, le temps déjà exécuté sur le projet.}

---

### Ouvrir le fichier de données

(par exemple pour changer le nom ou voir le nombre de minutes de travail.

~~~
http://localhost:8000?d=<id projet>
~~~



<a name="define-projet"></a>

---

### Définir le projet

La seule chose à prévoir au départ est la définition du projet. Un **projet (todoist)** se définit par :

* un **identifiant** (le plus court et le plus simple possible, comme `digest`, car on aura à l’employer souvent)
* un **dossier** dans le finder (chemin d’accès absolu qui sera la racine du projet).
* un **titre** humain.

On peut définir ce projet de deux manières différentes :

* soit en éditant le fichier `PROJETS.yaml` de ce dossier programme.
* soit en envoyant une commande depuis une tâche qui contiendra : **`http://localhost:8000?create=idprojet:/path/to/projet:Titre_du_projet`**

> Noter qu’on peut aussi redéfinir un chemin d’accès de cette manière.
>
> Noter que les **espaces doivent être replacées** par des `_` dans le titre du projet.



## Annexes

<a name="identifiant-projet"></a>

---

### Identifiant du projet

L’identifiant du projet est un nom court, si possible tout en minuscule et seulement avec lettres « a » à « z » (simplement pour être tapé plus facilement). Il permet de faire référence à un projet particulier, c’est-à-dire, précisément, à son dossier.

Voir la procédure [Définir un projet](#define-projet) pour savoir comment le définir directement dans une tâche Todoist.

<a name="query-string"></a>

---

### Le query-string

Le « *query-string* » ou « *paramètres d’URL* » est la partie de l’URL après le point d’interrogation (« ? »), qui définit les paramètres dont aura besoin de le serveur pour exécuter une opération.

Par exemple :

~~~bash
http://localhost:8000?o=monprojet&ide=1
~~~

Ci-dessus, le *query-string* est **`o=monprojet&ide=1`**. Il définit deux paramètres, « o » et « ide » qui ont respectivement la valeur « monprojet » et « 1 ».

---



[ID du projet]: #identifiant-projet
[query-string]: #query-string
