require 'parser'

class Config
  attr_reader :file_path, :overrides, :groups

  def initialize(file_path, overrides)
    @file_path = file_path
    @overrides = overrides.map{ |o| o.to_s }
    @groups = GroupCollection.new

    Parser.parse(self)
  end

  def method_missing(method_name, *args)
    @groups[method_name]
  end
end