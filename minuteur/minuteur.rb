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
    # SWA TodoistServer sinon au prochain appel le minuteur ne se remet pas.
    def close(projetId)
      # system('osascript', '-e', 'tell application "System Events" to tell process "TodoistServer" to click button 1 of (every window whose name is "minuteur")')
      # system('osascript', '-e', 'tell application "System Events" to tell process "TodoistServer" to quit')
      system('osascript', '-e', 'tell application "System Events" to tell process "TodoistServer" to keystroke "q" using command down')
      puts "Fermeture du minuteur (projet « #{Projet.get(projetId)&.name || 'inconnu'} »)"
      nil
    end

  end #/ << self
end #/class Minuteur