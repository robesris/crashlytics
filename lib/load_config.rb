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
  ARRAY =                    /^\s*(\D\w*)\s*=\s*(.*,.*)$/
  BOOLEAN =                  /^\s*(\D\w*)\s*=\s*(no|yes|true|false)\s*$/i
  TRUE_VALUES = ['yes', 'true']
  FALSE_VALUES = ['no', 'false']

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
      when BOOLEAN
        value = $2
        @current_group[$1.to_sym] = TRUE_VALUES.include?(value)
      when SYMMETRIC_QUOTED_STRING
        @current_group[$1.to_sym] = $3
      when ASYMMETRIC_QUOTED_STRING
        @current_group[$1.to_sym] = $2
      when ARRAY
        values = $2.split(',')
        @current_group[$1.to_sym] = values
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
      end
    end
  end
end