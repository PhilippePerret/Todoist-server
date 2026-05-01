class Script

  def eval_as_tss_ascript
    compose_code
    nil
  end

  def compose_code
    code.split("\n").each do |line|
      line = line.strip.downcase
      next if line.start_with?('# ')
      case line
      when /^afficher le dossier$/, /^open folder$/
        projet.open_in_finder
        puts "⚙️ Ouverture du dossier"
      when /^(?:nouvelle version|nouveau) patch de "(.+?)"$/, /^new path version of "(.+?)"$/
        new_version_of($1.freeze, :patch)
      when /^nouvelle version mineure? de "(.+?)"$/, /^new minor version of "(.+?)"$/
        new_version_of($1.freeze, :minor)
      when  /^nouvelle version majeure? de "(.+?)"$/, /^new major version of "(.+?)"$/
        new_version_of($1.freeze, :major)
      when /^ouvrir le fichier "(.+?)"/, /^open file "(.+?)"/
        ref_name = $1.freeze
        ref_path = File.join(projet.folder, ref_name)
        candidat = Fichier.find_as_versioned(ref_path)
        candidat = ref_path if !candidat && File.exist?(ref_path)
        Fichier.new(candidat).open if candidat
      end
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