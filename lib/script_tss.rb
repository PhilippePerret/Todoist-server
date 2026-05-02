class Script

  def eval_as_tss_ascript
    compose_code
    nil
  end

  def compose_code
    minuteur = nil
    code.split("\n").each do |line|
      line = line.strip
      next if line.start_with?('# ')
      case line
      when /^(?:régler un )?minuteur de (?<heures>[0-9]+):(?<minutes>[0-9]+)$/, /^set timer to (?<heures>[0-9]+):(?<minutes>[0-9]+)$/
        minuteur = $~[:heures].to_i * 60 + $~[:minutes].to_i
      when /^afficher le dossier$/, /^ouvrir le dossier$/, /^open folder$/i
        projet.open_in_finder
        puts "⚙️ Ouverture du dossier"
      when /^(?:nouvelle version|nouveau) patch de "(.+?)"$/, /^new path version of "(.+?)"$/i
        new_version_of($1.freeze, :patch)
      when /^nouvelle version mineure? de "(.+?)"$/, /^new minor version of "(.+?)"$/i
        new_version_of($1.freeze, :minor)
      when  /^nouvelle version majeure? de "(.+?)"$/, /^new major version of "(.+?)"$/i
        new_version_of($1.freeze, :major)
      when /^ouvrir le fichier "(.+?)"/, /^open file "(.+?)"/i
        ref_name = $1.freeze
        ref_path = File.join(projet.folder, ref_name)
        candidat = Fichier.find_as_versioned(ref_path)
        candidat = ref_path if !candidat && File.exist?(ref_path)
        Fichier.new(candidat).open if candidat
      else
        erreur("Je ne connais pas la commande #{line.inspect}")
      end
    end

    # Si un minuteur doit être déclenché, il faut ne le faire qu'ici car
    # il exit du programme
    if minuteur
      require_relative '../minuteur/minuteur'
      Minuteur.run(minuteur)
    end
  end



  def new_version_of(ref_name, version_type)
    candidat = Fichier.find_as_versioned(File.join(projet.folder, ref_name))
    if candidat
      fichier = Fichier.new(candidat)
      res = case version_type
      when :patch then fichier.do_next_patch_version
      when :minor then fichier.do_next_minor_version
      when :major then fichier.do_next_major_version
      end
      if res
        puts "⚙️ Nouvelle version #{version_type} de #{File.basename(candidat).inspect}"
      else
        return ''
      end
    else
      erreur("Impossible de trouver un fichier versionné à partir de #{ref_name.inspect}.")
    end

  end
end