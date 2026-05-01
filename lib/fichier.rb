class Fichier

  def self.get(path)
    if File.exist?(path)
      Fichier.new(path)
    else
      raise "Le fichier ou dossier `#{path}' est introuvable."
    end
  end

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def open
    `open "#{path}"`
  end

end