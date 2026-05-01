require 'yaml'
require 'json'
require 'fileutils'
require_relative 'error'

MONTHS_FR = %w[janvier février mars avril mai juin juillet août septembre octobre novembre décembre]

YAML_OPTIONS = {symbolize_names:true, aliases: true, permitted_classes: [Symbol, TrueClass, FalseClass]}.freeze
