class Minuteur
  class << self

    def run(projetId, minutes, params)
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

  end #/ << self
end #/class Minuteur