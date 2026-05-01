# Historique de travail — Todoist-server

## Architecture du projet (2026-04-28)
Serveur HTTP local (Python 3, stdlib) + handler Ruby.
- `server.py` — écoute sur 127.0.0.1:5005 ; reçoit les GET, extrait la query-string et lance `handler.rb` en sous-processus détaché (204 immédiat).
- `handler.rb` — reçoit la query-string en ARGV[0], la parse avec CGI.parse ; actuellement gère `?p=digest` (ouvre le Finder sur un dossier) et logge les cas inconnus dans `todoist-server.log`.
- `Todoist-Server.app` — bundle macOS (probablement un wrapper pour lancer le serveur).

## Session 2026-04-28
- Prise en main du projet : lecture des deux fichiers sources et mise en place du journal de travail.
- Création de `timer_lib.rb` : librairie autonome `TimerLib.start(minutes)` qui ouvre Horloge.app sur l'onglet Minuteur via AppleScript/System Events, règle la durée, démarre le timer, notifie 10 min avant la fin (bannière macOS), et met l'app au premier plan à la fin.
- Intégration dans `handler.rb` : `require_relative 'timer_lib'` + appel `TimerLib.start(t) if t` sur le paramètre `?t=<minutes>`.
- Fusion minuteur dans la fenêtre 5005 : `handler.rb` sert `timer.html` directement (conversion minutes→secondes injectée), plus de spawn `timer.rb`. AppleScript (bring-to-front) déclenché par les signaux JS `?warn`, `?done`. `?stop=true&elapsed=X` et `?done=true&elapsed=X` mettent `elapsed` (secondes jouées, pauses exclues) disponible dans `handler.rb`.
- `timer.html` : ajout boutons Pause/Reprendre et Stop, tracking elapsed correct (pauses exclues via `totalPaused`).
- `server.py` : détection automatique HTML pour servir `text/html`.
- `timer.html` : ajout panneau todo (markdown, visible pendant le minuteur), état pré-lancement si TodoContent, état bilan post-stop (2 textareas done/todo + Valider). `validerBilan()` envoie `?stop=true&elapsed&p&done&todo`.
- `handler.rb` : injection `TodoContent` (placeholder ligne 41), récupération `done_md`/`todo_md`/`projet_id` au stop. Fenêtre agrandie à {80,40,760,900}.
