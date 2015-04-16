require 'ostruct'

def load_config(file_path, overrides=[])
  Config.new(file_path)
end

class Config < OpenStruct
  def initialize(file_path)
    super()
    @file_path = file_path
    @current_group = nil
    parse
  end

  def parse
    File.read(@file_path).each_line do |line|
    case line
      when /\s*\[(\w+)\]\s*/
        @current_group = $1.to_sym
        self[@current_group] = OpenStruct.new
      else
      end
    end
  end
end