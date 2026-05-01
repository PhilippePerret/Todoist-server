require 'yaml'
require 'json'

MONTHS_FR = %w[janvier février mars avril mai juin juillet août septembre octobre novembre décembre]

YAML_OPTIONS = {symbolize_names:true, aliases: true, permitted_classes: [Symbol, TrueClass, FalseClass]}.freeze
