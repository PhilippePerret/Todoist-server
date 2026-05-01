# Script de projet

*(petite définition avant toute chose : une autre aide parle de « scripter un projet ». Cela désigne tout le fonctionnement de ce Todoist Server qui permet de commander un projet pour ouvrir toutes les possibilités des tâches. Ici, on apprend à **créer un script de projet**, c’est-à-dire un fichier qui va exécuter une opération précise sur le projet, par exemple changer la version d’un manuscrit et l’ouvrir)*

## Présentation

Il existe **TROIS FORMES de scripts** dans Todoist-Server.

* Les **scripts TSS** (pour Todois Server Script) qui utilisent des commandes propres à Todoist-Server et donc sont limités aux commandes existantes (mais qui peuvent évoler au fur et à mesure des demandes et besoins des utilisateurs. **C’est le type de script des utilisateurs qui ne programment pas du tout.**
  Leur extension est **`.tss`**
  En savoir plus sur [les scripts TSS](#tss-scripts).

* *[Programmeurs]* Les **scripts BASH** (du nom du prompt du Terminal) qui ne possèdent aucune limite d’aucune sorte. À partir du moment où le Terminal peut jouer la commande — le script — elle est utilisable comme script pour todoist-serveur.
  Leur extension est **`.sh`**
  En savoir plus sur [les scripts Bash](#bash-scripts).

* *[Programmeurs]* Les **Scripts exécutables** qui eux non plus ne possèdent aucune limite, et sont exécutés tels quels, à l’intérieur du dossier du projet, en fonction de leur extension. Par exemple, si un script possède l’extension `.rb`, il sera exécuté par la commande `ruby ./<script>`. Si l’extension est `.py`, il sera exécuté par la commande `python3 ./<string>`, etc.
  Leur extension dépend de leur langage.
  En savoir plus sur [les scripts exécutables](#exec-scripts).

  > Malgré leur nom, ces scripts n’ont pas besoin d’être rendus exécutables.

---

## Les types de script

<a name="tss-scripts"></a>

### Les script TSS

Ce type de script est le plus simple, puisqu’il se compose à l’aide de commandes « humaines » mais c’est aussi le plus limité. On ne peut utiliser que les commandes définies par l’application.

> ATTENTION : si ces commandes sont plus simples car plus humaine, elles n’en restent pas moins des « commandes » et, donc, nécessitent de respecter leur expression à la virgule près. 😊

Ce script se présente simplement comme une liste de commandes les unes au-dessous des autres. Par exemple : 

~~~bash
# Ceci est un commentaire
afficher le dossier
nouvelle version mineure de "roman.odt"
ouvrir le fichier "roman_v.odt"
~~~



Ces commandes sont les suivantes :

| Produit                         | Description                                                  |
| ------------------------------- | ------------------------------------------------------------ |
| Pour créer une nouvelle version | [Nouvelle version majeure](#new-major-version)<br />[Nouvelle version mineur](#new-minor-version)<br />[Nouvelle version patch](#new-patch-version) |
| Ouvrir un fichier versionné     | [Ouvrir un fichier versionné](#open-versioned-file)          |
| Ouvrir un fichier précis        | [Ouvrir un fichier](#open-file)                              |
|                                 |                                                              |

<a name="new-major-version"></a>

---

### **Nouvelle version majeure**

Fera passer le fichier `fichier-v12` à `fichier-v13`, le fichier `file-v12.5` à `file-v13.0`, etc.

**Commande anglaise**

~~~bash
new major version of "root name.ext"
~~~

**Commande française**

~~~bash
nouvelle version majeure de "nom racine.ext"
~~~

Si le fichier est `monfichier-v12.4.569.odt`, le **nom racine** est `monfichier.odt`. Ne pas oublier l’extension.


<a name="new-minor-version"></a>

---

### **Nouvelle version mineure**

<a name="new-patch-version"></a>

Fait passer le fichier `fichier-v12.4` et `roman-v12.4.13` à, respectivement `fichier-v12.5` et `roman-v12.5.0`.

**Commande anglaise**

~~~bash
new minor version of "root name.ext"
~~~

**Commande française**

~~~bash
nouvelle version mineure de "nom racine.ext"
~~~

Si le fichier est `monfichier-v12.4.569.odt`, le **nom racine** est `monfichier.odt`. Ne pas oublier l’extension.

---

### **Nouvelle version patch**

Fait passer le fichier `fichier_v12.4.5` à `fichier_v12.4.6`.

**Commande anglaise**

~~~bash
new patch version of "root name.ext"
new patch of "root name.ext"
~~~

**Commande française**

~~~bash
nouvelle version patch de "nom racine.ext"
nouveau patch de "nom racine.ext"
~~~

Si le fichier est `monfichier-v12.4.569.odt`, le **nom racine** est `monfichier.odt`. Ne pas oublier l’extension.

<a name="open-file"></a>

---

### **Ouvrir un fichier précis**

**Commande anglaise**

~~~bash
open file "mon_fichier_exact.md"
~~~

**Commande française**

~~~bash
ouvrir le fichier "mon_fichier_exact.md"
~~~




<a name="open-versioned-file"></a>

---

### **Ouvrir un fichier versionné**

Ouvre le fichier versionné courant d’empreinte « root name.odt ». L’empreinte est nécessaire car on ne connait jamais, *a priori*, le numéro de version courant du fichier.

**Commande anglaise**

~~~bash
open file "root name.odt"
~~~



**Commande française**

~~~bash
ouvrir le fichier "root name.odt"
~~~

Si le fichier exact s’appelle `root name-v2.12.odt`, c’est lui qui sera ouvert.



---

Une commande pour obtenir directement l’appel serveur à utiliser, pour le projet donné.




<a name="bash-scripts"></a>

---

### Les script Bash



Le script peut avoir n’importe quel langage et sera évalué dans le cadre du projet (à la racine du projet). Il peut servir à lancer un script ruby, par exemple : 

~~~bash
ruby ./citation.rb
~~~


<a name="exec-scripts"></a>

---

### Le script exécutables


---

Leur contenu doit dépendre entièrement du langage et de l’opération désirée. 

Tous ce qu’il renverra à la sortie standard sera écrit dans la fenêtre de Todoist-Server. On peut donc aussi se servir de ces scripts pour obtenir des informations sur le projet. Par exemple, imaginons un script ruby qui doit retourner le nombre de fichiers, le nombre de dossiers et la taille du projet en python.

~~~python
import os

files = folders = total_size = 0

for dirpath, dirnames, filenames in os.walk('.'):
    folders += len(dirnames)
    files += len(filenames)
    for f in filenames:
        total_size += os.path.getsize(os.path.join(dirpath, f))

if total_size >= 1_000_000:
    size_str = f"{total_size / 1_000_000:.2f} Mo"
else:
    size_str = f"{total_size / 1_000:.2f} Ko"

print(f"Nombre de fichiers : {files}")
print(f"Nombre de dossiers : {folders}")
print(f"Taille totale : {size_str}")
~~~

#### Les script javascript

Les scripts javascript (`.js` ou `.ts`) sont évalués par `bun`. On se sert de `console.log` pour produire un affichage.

---

## Utiliser les scripts

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
