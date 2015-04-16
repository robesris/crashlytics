def load_config(file_path, overrides=[])
  Config.new(file_path)
end

class Config
  def initialize(file_path)
    @data = {}

    File.read(file_path).each_line do |line|
    case line
      when /\s*\[(\w+)\]\s*/
        @data[$1.to_sym] = {}
      end
    end
  end

  def method_missing(method_name)
    @data[method_name]
  end
end