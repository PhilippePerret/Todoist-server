class Minuteur
  class << self

    def run(time)
      t_sec = (t_min.to_f * 60).to_i
      html  = File.read(File.join(__dir__, 'minuteur', 'timer.html'))
      html  = html.sub("urlParams.get('t') || '300'", "'#{t_sec}'")
      # Injection des tâches à faire (remplir la variable ci-dessous)
      todo_md = Projet.get(param(params, 'p'))&.todo
      html  = html.sub('const TodoContent = null', "const TodoContent = #{todo_md.to_json}")
      # Redimensionner la fenêtre Safari après chargement de la page
      pid = spawn('/bin/sh', '-c',
    'sleep 1.5 && osascript -e \'tell application "System Events" to tell process "TodoistServer" to set position of window 1 to {80, 40}\' && osascript -e \'tell application "System Events" to tell process "TodoistServer" to set size of window 1 to {680, 860}\'',
        in: '/dev/null', out: '/dev/null', err: '/dev/null')
      Process.detach(pid)
      puts html
      exit 0
    end

  end #/ << self
end #/class Minuteur