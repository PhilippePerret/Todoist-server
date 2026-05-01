class Script

  def self.get(projet, root_name)
    script = Script.new(projet, root_name)
    if script.exist?
      script
    else
      nil
    end
  end


  attr_reader :projet
  attr_reader :root_name

  def initialize(projet, root_name)
    @projet = projet
    @root_name = root_name
  end

  def run
    final_code = <<~BASH
    #!/usr/bin/env zsh
    cd "#{projet.path}"
    #{code}
    BASH

    res = `#{final_code} 2>&1`
    "\n\n#{res}"
  end

  def code = @code ||= IO.read(path)

  def exist? = File.exist?(path)

  def path = @path ||= File.join(projet.path, 'scripts', "#{root_name}.sh")

end #/class Script