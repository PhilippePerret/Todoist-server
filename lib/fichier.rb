class Fichier

  ERR_NO_VERSIONNABLE  = "Le fichier n'est pas versionné, impossible de passer à la version majeure suivante."
  ERR_NO_MINOR_VERSION = "Le fichier ne définit pas de version mineure."
  ERR_NO_PATCH_VERSION = "Le fichier ne définit pas de version de patch"

  def self.get(path)
    if File.exist?(path)
      Fichier.new(path)
    else
      raise "Le fichier ou dossier `#{path}' est introuvable."
    end
  end

  attr_reader :path

  def initialize(path)
    @path = File.realpath(path)
  end

  # Commande pour ouvrir le fichier
  def open
    `open "#{path}"`
  end

  # Produire la version majeure suivante
  def do_next_major_version
    return erreur_not_versionable unless versioned?
    FileUtils.copy(path, next_major_version_file)
    archive_file
  end


  # Produire la version mineur suivante
  def do_next_minor_version
    return erreur_not_versionable unless versioned?
    return erreur(ERR_NO_MINOR_VERSION) unless minor_version
    FileUtils.copy(path, next_minor_version_file)
    archive_file
  end

  def do_next_patch_version
    return erreur_not_versionable unless versioned?
    return erreur(ERR_NO_PATCH_VERSION) unless patch_version
    FileUtils.copy(path, next_patch_version_file)
    archive_file
  end

  # Met le fichier courant en archive
  def archive_file
    FileUtils.move(path, archive_path)
  end

  def erreur_not_versionable
    erreur([ERR_NO_VERSIONNABLE,
      "Ajouter `_vX.Y.Z` au nom du fichier pour le rendre versionnable.",
      "(en remplaçant X, Y et Z par des nombres, évidemment.)"])
  end

  def exist? = File.exist?(path)
  def versioned? = !decomposed_name[:major_version].nil?

  def name    = @name     ||= decomposed_name[:name]
  def folder  = @folder   ||= decomposed_name[:folder]
  def extname = @extname  ||= decomposed_name[:extname]
  def major_version = @major_version  ||= decomposed_name[:major_version]
  def minor_version = @minor_version  ||= decomposed_name[:minor_version]
  def patch_version = @patch_version  ||= decomposed_name[:patch_version]

  # Nom root, ie sans extension mais aussi sans numéro de version
  def very_root_name = @very_root_name ||= decomposed_name[:very_root_name]

  def root_name = @root_name ||= decomposed_name[:root_name]

  def next_major_version_file
    File.join(folder, "#{next_major_version}#{extname}")
  end
  def next_minor_version_file
    File.join(folder, "#{next_minor_version}#{extname}")
  end
  def next_patch_version_file
    File.join(folder, "#{next_patch_version}#{extname}")
  end

  def archive_path = @archive_path ||= File.join(archive_folder, name)
  def archive_folder
    @archive_folder ||= begin
      File.join(folder, 'xArchives').tap {|d| FileUtils.mkdir_p(d)}
    end
  end

  def next_major_version
    compose_name(major_version && major_version + 1, 0, 0)
  end
  def next_minor_version
    compose_name(
      major_version, 
      minor_version && minor_version + 1, 
      0
    )
  end
  def next_patch_version
    compose_name(
      major_version,
      minor_version,
      patch_version && patch_version + 1
    )
  end

  def compose_name(majorv, minorv, patchv)
    nf = very_root_name
    if versioned?
      nf += "#{decomposed_name[:v_delimitor]}v"
      if majorv
        nf += "#{majorv}"
        if decomposed_name[:minor_version]
          nf += ".#{minorv}"
          if decomposed_name[:patch_version]
            nf += ".#{patchv}"
          end
        end
      end
    end
    return nf
  end
  # Décomposition du nom
  def decomposed_name
    @decomposed_name ||= begin
      name = File.basename(path)
      folder = File.dirname(path)
      extname = File.extname(path)
      root_name = File.basename(path, extname)
      major_version = nil
      minor_version = nil
      patch_version = nil
      v_delimitor   = nil
      very_root_name = root_name.gsub(/^(?<roots>.+?)((?<del>.)v(?<major>[0-9]+)(\.(?<minor>[0-9]+))?(\.(?<patch>[0-9]+))?)?$/) do
        major_version = $~[:major]&.to_i
        minor_version = $~[:minor]&.to_i
        patch_version = $~[:patch]&.to_i
        v_delimitor = $~[:del]
        $~[:roots]
      end

      {
        folder: folder,
        name: name, 
        extname: extname, 
        root_name: root_name, 
        major_version: major_version, 
        minor_version: minor_version, 
        patch_version: patch_version, 
        very_root_name: very_root_name,
        v_delimitor: v_delimitor
      }
    end
  end

end

if $0 == __FILE__
  require_relative 'constants'
  FILENAME = "module #{File.basename(__FILE__).inspect}"
  puts "Je teste le #{FILENAME}"
  # -- Dossier --
  fichier = Fichier.new("./lib")
  puts "Fichier testé : #{fichier.path.inspect}"
  fichier.name == "lib" || raise("Le .name devrait être 'lib', il vaut #{fichier.name.inspect}")
  fichier.root_name == "lib" || raise("Le .root_name devrait être 'lib', il vaut #{fichier.root_name.inspect}")
  # -- Dossier avec version --

  # -- Fichier --
  fichier = Fichier.new("./lib/projet.rb")
  fichier.exist? || raise("Le fichier projet.rb devrait exister.")
  fichier.name == "projet.rb" || raise("Le .name devrait être 'projet.rb', il vaut #{fichier.name.inspect}")
  fichier.root_name == "projet" || raise("Le .root_name devrait être 'projet', il vaut #{fichier.root_name.inspect}")
  fichier.very_root_name == "projet" || raise("Le .very_root_name devrait être 'projet', il vaut #{fichier.root_name.inspect}")
  fichier.next_major_version == "projet" || raise("Le .next_major_version devrait être 'projet', il vaut #{fichier.next_major_version.inspect}")
  fichier.next_minor_version == "projet" || raise("Le .next_minor_version devrait être 'projet', il vaut #{fichier.next_minor_version.inspect}")
  fichier.next_patch_version == "projet" || raise("Le .next_patch_version devrait être 'projet', il vaut #{fichier.next_patch_version.inspect}")
  # -- Fichier avec version majeur --
  fichier = Fichier.new("./lib/tests/assets/fichier_version_v1.md")
  fichier.name == "fichier_version_v1.md" || raise("le .name devait être 'fichier_version_v1.md', il vaut #{fichier.name.inspect}")
  fichier.root_name == "fichier_version_v1" || raise("Le .root_name devrait être 'fichier_version_v1', il vaut #{fichier.root_name.inspect}")
  fichier.very_root_name == "fichier_version" || raise("Le .very_root_name devrait être 'fichier_version', il vaut #{fichier.root_name.inspect}")
  fichier.next_major_version == "fichier_version_v2" || raise("Le .next_major_version devrait être 'fichier_version_v2', il vaut #{fichier.next_major_version.inspect}")
  fichier.next_minor_version == "fichier_version_v1" || raise("Le .next_minor_version devrait être 'fichier_version_v1', il vaut #{fichier.next_minor_version.inspect}")
  fichier.next_patch_version == "fichier_version_v1" || raise("Le .next_patch_version devrait être 'fichier_version_v1', il vaut #{fichier.next_patch_version.inspect}")
  File.basename(fichier.next_major_version_file) == 'fichier_version_v2.md' || raise("Mauvais nom #{File.basename(fichier.next_major_version_file).inspect}")
  File.delete(fichier.next_major_version_file) if File.exist?(fichier.next_major_version_file)
  fichier.do_next_major_version
  File.exist?(fichier.next_major_version_file) || raise("La version suivante devrait avoir été produite.")
  !File.exist?(fichier.path) || raise("Le fichier original ne devrait plus exister")
  File.exist?(fichier.archive_path) || raise("Le fichier devrait avoir été mis en archive.")
  FileUtils.move(fichier.archive_path, fichier.path)
  File.delete(fichier.next_major_version_file)
  # On ne doit pas pouvoir en faire une version mineur
  fichier.do_next_minor_version
  File.exist?(fichier.path) || raise("Le fichier n'aurait pas dû être versionné")
  Error.get.include?(Fichier::ERR_NO_MINOR_VERSION) || raise("Une erreur aurait dû être signalée.")
  Error.flush

  # -- Fichier avec version majeure et mineure --
  fichier = Fichier.new("./lib/tests/assets/fichier_version_v2.23.md")
  fichier.name == "fichier_version_v2.23.md" || raise("le .name devait être 'fichier_version_v2.23.md', il vaut #{fichier.name.inspect}")
  fichier.root_name == "fichier_version_v2.23" || raise("Le .root_name devrait être 'fichier_version_v1.23', il vaut #{fichier.root_name.inspect}")
  fichier.very_root_name == "fichier_version" || raise("Le .very_root_name devrait être 'fichier_version', il vaut #{fichier.root_name.inspect}")
  fichier.next_major_version == "fichier_version_v3.0" || raise("Le .next_major_version devrait être 'fichier_version_v3.0', il vaut #{fichier.next_major_version.inspect}")
  fichier.next_minor_version == "fichier_version_v2.24" || raise("Le .next_minor_version devrait être 'fichier_version_v2.24', il vaut #{fichier.next_minor_version.inspect}")
  fichier.next_patch_version == "fichier_version_v2.23" || raise("Le .next_patch_version devrait être 'fichier_version_v2.23', il vaut #{fichier.next_patch_version.inspect}")
  # On produit la version suivante
  File.delete(fichier.next_minor_version_file) if File.exist?(fichier.next_minor_version_file)
  fichier.do_next_minor_version
  File.exist?(fichier.next_minor_version_file)
  !File.exist?(fichier.path) || raise("Le fichier original aurait dû être déplacé")
  File.exist?(fichier.archive_path) || raise("Le fichier aurait dû être mis en archive")
  # On défait
  FileUtils.move(fichier.archive_path, fichier.path)
  File.delete(fichier.next_minor_version_file)
  # On ne doit pas pouvoir faire de nouvelle version patch
  fichier.do_next_patch_version
  File.exist?(fichier.path) || raise("Le fichier original n'aurait pas dû être touché")
  Error.get.include?(Fichier::ERR_NO_PATCH_VERSION) || raise("Une erreur aurait dû être signalée.")
  Error.flush


  # -- Fichier avec version majeure et mineure et patch --
  fichier = Fichier.new("./lib/tests/assets/fichier_version_v3.56.2564.md")
  fichier.name == "fichier_version_v3.56.2564.md" || raise("le .name devait être 'fichier_version_v3.56.2564.md', il vaut #{fichier.name.inspect}")
  fichier.root_name == "fichier_version_v3.56.2564" || raise("Le .root_name devrait être 'fichier_version_v3.56.2564', il vaut #{fichier.root_name.inspect}")
  fichier.very_root_name == "fichier_version" || raise("Le .very_root_name devrait être 'fichier_version', il vaut #{fichier.root_name.inspect}")
  fichier.next_major_version == "fichier_version_v4.0.0" || raise("Le .next_major_version devrait être 'fichier_version_v4.0.0', il vaut #{fichier.next_major_version.inspect}")
  fichier.next_minor_version == "fichier_version_v3.57.0" || raise("Le .next_minor_version devrait être 'fichier_version_v3.57.0', il vaut #{fichier.next_minor_version.inspect}")
  fichier.next_patch_version == "fichier_version_v3.56.2565" || raise("Le .next_patch_version devrait être 'fichier_version_v3.56.2565', il vaut #{fichier.next_patch_version.inspect}")
  # On peut produire une version patch suivante
  File.delete(fichier.next_patch_version_file) if File.exist?(fichier.next_patch_version_file)
  fichier.do_next_patch_version
  File.exist?(fichier.next_patch_version_file) || raise("La nouvelle version aurait dû être produite")
  File.exist?(fichier.archive_path) || raise("La version courante aurait dû être mise en archive")
  # On défait
  FileUtils.move(fichier.archive_path, fichier.path)
  File.delete(fichier.next_patch_version_file)
  
  # -- Fichier avec délimiteur différent --
  fichier = Fichier.new("./lib/tests/assets/fichier_version-v12.md")
  fichier.very_root_name == "fichier_version" || raise("Le .very_root_name devrait être 'fichier_version', il vaut #{fichier.very_root_name.inspect}.")
  fichier.next_patch_version == 'fichier_version-v12' || raise("Mauvais nom : #{fichier.next_patch_version.inspect}")
  fichier.next_major_version == 'fichier_version-v13' || raise("Mauvais nom : #{fichier.next_major_version.inspect}")
  puts "👌 Le #{FILENAME} est opérationnel."
end