class Projet

  def self.get(ref)
    Projet.new(ref)
  rescue Exception => e
    puts "#{e.message}"
    return nil
  end

  def self.getByName(ref)
    dataProjets = YAML.safe_load(IO.read(datafile), **YAML_OPTIONS)
    dataProjets[ref.to_sym]
  end

  def self.define(id, path, name)
    dataProjets = YAML.safe_load(IO.read(datafile), **YAML_OPTIONS)
    if dataProjets[id.to_sym]
      dataProjets[id.to_sym] = path
    else
      dataProjets.store(id, path)
    end
    IO.write(datafile, dataProjets.to_yaml)
    puts "J'ai défini le projet d'identifiant #{id.inspect}, de path `#{path}' et de nom #{name.inspect}."
    # -- On crée le dossier data du projet --
    if projet = get(id)
      name = name.gsub(/_/, ' ')
      projet.name = name
      projet.save_data
    end
  end

  def self.datafile = @@datafile ||= './PROJETS.yaml'


  attr_reader :id, :path
  alias :folder :path

  def initialize(id)
    @id   = id
    @path = Projet.getByName(id) || raise("Impossible de trouver le projet `#{id}'. Il faut l'ajouter à PROJETS.yaml de programmes/todoist_server.")
  end

  # -- Permet de jouer le script +script+ du projet --
  # -- Aide : Project Script ---
  def run_script(script_root)
    require_relative 'script'
    if script = Script.get(self, script_root)
      # puts "script: #{script.inspect}"
      puts script.run
      puts "🥳 Script #{script_root.inspect} joué avec succès."
    else
      erreur("Impossible de trouver le script #{script_root}")
    end
  end

  def addWorkedTime(secondes, saveit = true)
    @data[:work_time] = data[:work_time] + secondes
    save_data if saveit
  end

  def addChangeLog(content)
    now = Time.now
    date_fr = "#{now.day} #{MONTHS_FR[now.month - 1]} #{now.year}"
    init_changelog_file unless File.exist?(changelogfile)
    File.open(changelogfile, "a") { |f| f.write("\n\n### #{date_fr}\n\n#{content}") }
  end

  def addTodoContent(content, saveit = false)
    @data[:todo] = content
    save_data if saveit
  end

  def open(mode)
    mode ||= 'finder'
    case mode
    when 'finder' then open_in_finder
    when 'ide' then open_in_ide
    else puts "Le mode d'ouverture #{mode.inspect} est inconnu (soit 'finder', soit 'ide', soit rien)."
    end
  end

  def open_in_finder
    `open -a Finder "#{path}"`
    puts "Projet « #{name} » ouvert dans le Finder."
  end

  def open_in_ide
    `source ~/.zshrc && code "#{path}"`
    puts "Projet « #{name} » ouvert dans VSCode"
  end

  def open_data_file
    `open -a CotEditor #{datafile}`
  end

  def todo
    data[:todo]
  end

  def name
    data[:name] || @id
  end
  def name=(value)
    data.store(:name, value)
  end

  def save_data
    IO.write(datafile, data.to_yaml)
  end
  def data
    @data ||= begin
      build_datafile unless File.exist?(datafile)
      YAML.safe_load(IO.read(datafile), **YAML_OPTIONS)
    end
  end

  def build_datafile
    IO.write(datafile, <<~YAML)
    ---
    id: #{id}
    name: #{id} # à remplacer
    work_time: 0
    YAML
  end

  # Fichier des données
  def datafile = @datafile ||= File.join(path, '.todoist_data')

  # Fichier change log
  def changelogfile = @changelogfile ||= File.join(path, 'CHANGELOG.md')
  def init_changelog_file
    IO.write(changelogfile, "# Work log")
  end

end