require 'ostruct'

def load_config(file_path, overrides=[])
  Config.new(file_path)
end

class Config < OpenStruct
  GROUP =                    /^\s*\[(\w+)\]\s*$/
  GENERIC =                  /^\s*(\D\w*)\s*=\s*(\S+)\s*$/
  INTEGER =                  /^\d+$/
  FLOAT =                    /^\d*\.\d+$/
  SYMMETRIC_QUOTED_STRING =  /^\s*(\D\w*)\s*=\s*("')([^"']*)\2\s*$/
  ASYMMETRIC_QUOTED_STRING = /^\s*(\D\w*)\s*=\s*“([^”]*)”\s*$/

  def initialize(file_path)
    super()
    @file_path = file_path
    @current_group = nil
    parse
  end

  def parse
    File.read(@file_path).each_line do |line|
    case line
      when GROUP
        @current_group = OpenStruct.new
        self[$1.to_sym] = @current_group
      when GENERIC
        key = $1.to_sym
        value = $2.to_s
        case value
        when INTEGER
          value = value.to_i
        when FLOAT
          value = value.to_f
        end

        @current_group[key] = value
      when SYMMETRIC_QUOTED_STRING
        @current_group[$1.to_sym] = $3
      when ASYMMETRIC_QUOTED_STRING
        @current_group[$1.to_sym] = $2
      end
    end
  end
end