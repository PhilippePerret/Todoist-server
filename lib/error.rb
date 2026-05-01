class Error
  class << self

    attr_reader :errors

    # Retourne les erreurs (pour les tests, pour le moment)
    def get
      @errors ||= []
      return errors
    end

    def add_errors(liste_erreurs)
      @errors ||= []
      @errors.concat(liste_erreurs)
    end

    # Pour les tests
    def flush
      @errors = []
    end

  end #/ << self

end #/class Error

def erreur(msg)
  msg = [msg] unless msg.is_a?(Array)
  Error.add_errors(msg)
  msg = msg.map { |seg| "### #{seg}" }.join("\n")
  puts msg
  return false
end

