module FileLoader
  def self.path(load_path)
    basename = File.basename(load_path, '.rb')
    $stdout.puts "#{basename}:" if ENV['DEBUG']

    files = Dir["#{File.dirname(load_path)}/#{basename}/*.rb"]

    if files.empty?
      puts '- empty'
    else
      files.sort.each { |file_path| load(file_path) }
    end
  end

  def self.load(path)
    require path
    $stdout.puts "- loaded #{File.basename(path)}" if ENV['DEBUG']
  end
end
