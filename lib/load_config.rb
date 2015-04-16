require 'ostruct'

def load_config(file_path, overrides=[])
  Config.new(file_path, overrides)
end

class GroupCollection < Hash
  def method_missing(method_name, *args)
    self[method_name.to_sym]
  end
end

class Config
  GROUP =                    /^\s*\[(\w+)\]\s*$/
  ASSIGNMENT =               /^\s*(\D\S*)\s*=\s*(.+)\s*$/
  INTEGER =                  /^\d+$/
  FLOAT =                    /^\d*\.\d+$/
  SYMMETRIC_QUOTED_STRING =  /^\s*(\D\w*)\s*=\s*("')([^"']*)\2\s*$/
  ASYMMETRIC_QUOTED_STRING = /^\s*(\D\w*)\s*=\s*“([^”]*)”\s*$/
  ARRAY =                    /^\s*(\D\w*)\s*=\s*(.*,.*)$/
  BOOLEAN =                  /^\s*(\D\w*)\s*=\s*(no|yes|true|false)\s*$/i
  TRUE_VALUES = ['yes', 'true']
  FALSE_VALUES = ['no', 'false']

  def initialize(file_path, overrides)
    @file_path = file_path
    @current_group = nil
    @overrides = overrides.map{ |o| o.to_s }
    @groups = GroupCollection.new

    parse
  end

  def method_missing(method_name, *args)
    @groups[method_name]
  end

  def parse
    File.read(@file_path).each_line do |line|
    case line
      when GROUP
        @current_group = GroupCollection.new
        @groups[$1.to_sym] = @current_group
      when ASSIGNMENT
        key = $1.to_sym
        value = $2

        override = nil
        if /(\w+)<([^>]+)>/ =~ key
          key = $1.to_sym
          override = $2
        end

        if @overrides.include?(override) || override.nil?
          case line
          when BOOLEAN
            value = $2
            @current_group[key] = TRUE_VALUES.include?(value)
          when SYMMETRIC_QUOTED_STRING
            @current_group[key] = $3
          when ASYMMETRIC_QUOTED_STRING
            @current_group[key] = $2
          when ARRAY
            values = $2.split(',')
            @current_group[key] = values
          when ASSIGNMENT
            value = $2.to_s
            case value
            when INTEGER
              value = value.to_i
            when FLOAT
              value = value.to_f
            end

            @current_group[key] = value
          else
            @current_group[key] = line
          end
        end
      end
    end
  end
end