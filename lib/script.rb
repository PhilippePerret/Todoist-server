class Script

  APP_BY_EXTNAME = {
    '.py' => 'python3',
    '.rb' => 'ruby',
    '.sh' => 'zsh',
    '.js' => 'bun',
    '.ts' => 'bun',
  }


  def self.get(projet, root_name)
    script = Script.new(projet, root_name)
    if script.exist?
      script
    else
      nil
    end
  end


  attr_reader :projet
  attr_reader :root_name, :ini_name, :name
  attr_reader :type

  def initialize(projet, ini_name)
    @projet = projet
    @ini_name = ini_name
    analyse_ini_name
  end


  def analyse_ini_name
    case extname = File.extname(ini_name)
    when nil, "" then
      @name = "#{ini_name}.sh"
      @type = :bash
    when ".tss"
      @name = ini_name
      @type = :tss
    else
      @name = ini_name
      @type = :self
    end
  end

  def run
    case type
    when :tss then run_as_tss_script
    when :bash then run_as_bash_script
    when :self then run_as_self_script
    end
  end

  def run_as_tss_script
    require_relative 'script_tss.rb'
    eval_as_tss_ascript
  end

  def run_as_self_script
    `source #{ENV['SHELL_RC']} 2>/dev/null && #{APP_BY_EXTNAME[File.extname(name)]} "#{path}"`
  end


  def run_as_bash_script
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

  def path = @path ||= File.join(projet.path, 'scripts', @name)

end #/class Script