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
      when /^\s*\[(\w+)\]\s*$/
        @current_group = OpenStruct.new
        self[$1.to_sym] = @current_group
      when /^\s*(\D\w*)\s*=\s*(\w+)\s*$/
        key = $1.to_sym
        value = $2
        case value
        when /^\d+$/
          value = value.to_i
        when /^\d*\.\d+$/
          value = value.to_f
        end
        @current_group[key] = value
      end
    end
  end
end