class Minuteur
  class << self

    def run(projetId, minutes)
      t_sec = (minutes.to_f * 60).to_i
      # Injection des tâches à faire (remplir la variable ci-dessous)
      todo_md = Projet.get(projetId)&.todo
      
      # Finaliser le code du timer
      html  = 
      File.read(File.join(__dir__, 'timer.html'))
      .sub("urlParams.get('t') || '300'", "'#{t_sec}'")
      .sub('const TodoContent = null', "const TodoContent = #{todo_md.to_json}")
      # Ouvrir le minuteur
      puts html

    end

    # Pour fermer le minuteur
    # Malheureusement, pour le moment, on est obligé de quitter l'application
    # SWA TodoistServer sinon au prochain appel le minuteur ne se remet pas…
    # Et puis il faut même relancer le serveur pour que le bon projet soit
    # pris en compte — c'est lourd, il faut vraiment trouver une solution…
    def close(projetId)
      # system('osascript', '-e', 'tell application "System Events" to tell process "TodoistServer" to click button 1 of (every window whose name is "minuteur")')
      # system('osascript', '-e', 'tell application "System Events" to tell process "TodoistServer" to quit')
      # system('osascript', '-e', 'tell application "System Events" to tell process "TodoistServer" to keystroke "q" using command down')
      # puts "Fermeture du minuteur (projet « #{Projet.get(projetId)&.name || 'inconnu'} »)"
      # # On force le rechargement du serveur
      # system('kill $(lsof -ti :8000); sleep 0.5; python3 /Users/philippeperret/Programmes/Todoist-server/server.py &')

      require_relative '../lib/server'
      Server.force_init

      nil
    end

  end #/ << self
end #/class Minuteur