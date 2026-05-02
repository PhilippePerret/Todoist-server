#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
#
# Pour tuer le serveur et le relancer :
# kill $(lsof -ti :8000); sleep 0.5; python3 /Users/philippeperret/Programmes/Todoist-server/server.py &
#
# Handler appelé par server.py.
# Reçoit la query-string brute en ARGV[0], en fournit une version parsée
# (CGI.parse → valeurs URL-décodées).
#
# C'est ICI que l'on fait évoluer le comportement : ajouter un paramètre
# dans Todoist, ajouter un traitement ci-dessous.

require_relative 'lib/constants'
require_relative 'lib/projet'
require_relative 'lib/fichier'
require 'cgi'

raw    = ARGV[0].to_s
params = CGI.parse(raw)
# params est un Hash<String, Array<String>>, valeurs déjà URL-décodées.
# Exemples :
#   "p=%2Fpath%2Fto%2Fscript"  →  {"p" => ["/path/to/script"]}
#   "p=/a&p=/b"                →  {"p" => ["/a", "/b"]}
#   ""                         →  {}

# Helper : première valeur d'un paramètre, ou nil.
def param(params, key)
  v = params[key]
  v && !v.empty? ? v.first : nil
end

# ── Minuteur : servir la page HTML dans la fenêtre 8000 ──────────────────
if minutes = param(params, 't')
  require_relative 'minuteur/minuteur'
  Minuteur.run(minutes)
end

# ── Signaux JS → AppleScript (réponses AJAX courtes) ─────────────────────
if param(params, 'warn') == 'true'
  system('osascript', '-e', 'tell application "TodoistServer" to activate')
  puts 'warn:ok'
  exit 0
end

if param(params, 'stop') == 'true'
  elapsed  = param(params, 'elapsed').to_i
  done_md  = param(params, 'done'); done_md = nil if done_md&.empty?
  todo_md  = param(params, 'todo'); todo_md = nil if todo_md&.empty?
  if projet = Projet.get(param(params, 'p'))
    # Si un projet est défini, on enregistre le temps de travail
    puts "Enregistrement du nouveau temps de travail\nProjet : #{projet.name}\nMinutes : #{elapsed / 60}"
    projet.addWorkedTime(elapsed, false)
    projet.addChangeLog(done_md) if done_md
    projet.addTodoContent(todo_md, false) if todo_md
    projet.save_data
  end
  exit 0
end

# ── Comportement standard ─────────────────────────────────────────────────
puts "RUBY VERSION : #{RUBY_VERSION}"
# puts "Entrée dans handler.rb"

# === À toi de jouer en dessous ===========================================
# `p_value` contient le chemin décodé passé via ?p=...
# Les autres paramètres sont accessibles via param(params, 'autre_clef')
# =========================================================================

# -- Ouverture d'un projet --
if o = param(params, 'o')
  if projet = Projet.get(o)
    projet.open(param(params,'mode'))
  end
end

# Ouverture des données du projet (pour modifications)
if d = param(params, 'd')
  if projet = Projet.get(o)
    projet.open_data_file
  end
end

# -- Ouverture d'un fichier quelconque --
if f = param(params, 'f')
  if fichier = Fichier.get(f)
    fichier.open
  end
end

# -- Jouer un script --
if script = param(params, 'script') || param(params, 'scp')
  if projet = Projet.get(param(params, 'p'))
    projet.run_script(script)
  else
    erreur([ 
      'Il faut définir le projet dans "p=" avec un identifiant connu.',
      'Exemple : http://localhost:8000?p=digest&script=monscript'
    ])
  end
end

# -- (Re)Définir un projet (create) --
if (data = param(params, 'create'))
  Projet.define(*data.split(':'))
end