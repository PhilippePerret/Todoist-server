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
- Port changé 5005→6000→8000 (6000 bloqué par Safari, 6000 = X11). Ajout Velja (routeur URL) + TodoistServer (Safari Web App) pour isoler le serveur de Safari.
- Icône SVG custom (style Todoist + badge serveur), appliquée via Get Info.
- `lib/script.rb` : correction `run()` — `echo #{code}` → `#{code}` (le script n'était pas exécuté, juste échô).
- Session 2026-05-02 :
  - timer.html : remplacement de requestAnimationFrame par setInterval(250ms) + Date.now() (fonctionne en background).
  - handler.rb warn= : ajout `set visible of process` avant activate.
  - open.sh : revenu à `open -a` simple (le `open -n` ouvrait trop d'instances).
  - TENTATIVE popup window.open() pour isoler le minuteur : à un moment (13h43) ça fonctionnait avec `window.open(popupUrl, 'todoist_timer', 'popup=yes,width=460,height=580,left=820,top=40')` + `pop.blur()`. Modifications successives ont cassé ce comportement et impossible de revenir en arrière (pas d'historique git utile, pas de console JS dans Safari Web App).
  - ÉTAT ACTUEL : popup ne s'ouvre plus. timer.html actuel tente `window.open(popupUrl, 'todoist_timer', 'width=460,height=580,left=770,top=40')` + `window.focus()` mais retombe en mode fenetre unique.
  - À FAIRE (session suivante) :
    1. Positionner correctement la fenêtre popup du minuteur à côté de la fenêtre principale via AppleScript (X_popup = X_main + W_main, Y identique). Le `window.open()` avec `left=770` ne suffit pas — il faut un AppleScript déclenché après l'ouverture de la popup, qui cible spécifiquement la fenêtre du minuteur (pas window 1 générique).
    2. Donner le focus à la fenêtre principale après ouverture de la popup (via `window.focus()` dans le JS de la fenêtre principale, appelé depuis le handler du clic DEMO).
    3. RAPPEL IMPORTANT : le minuteur est UNE fonctionnalité parmi d’autres (pas systématique). Quand il est utilisé : popup s’ouvre à côté, focus sur la fenêtre principale. Les autres commandes s’ouvrent normalement dans la fenêtre principale.
    - TODO: retrouver pourquoi le popup ne s'ouvre plus
