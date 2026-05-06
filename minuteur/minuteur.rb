class Minuteur
  class << self

    def run(projetId, minutes, params_hash = {})
      t_sec = (minutes.to_f * 60).to_i
      html  = File.read(File.join(__dir__, 'timer.html'))
      html  = html.sub("urlParams.get('t') || '300'", "'#{t_sec}'")
      # Injection des tâches à faire (remplir la variable ci-dessous)
      todo_md = Projet.get(projetId)&.todo
      html  = html.sub('const TodoContent = null', "const TodoContent = #{todo_md.to_json}")
      puts html
      exit 0
    end

  end #/ << self
end #/class Minuteur