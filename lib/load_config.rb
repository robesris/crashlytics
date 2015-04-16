require 'ostruct'
require 'config'
require 'group_collection'

def load_config(file_path, overrides=[])
  Config.new(file_path, overrides)
end