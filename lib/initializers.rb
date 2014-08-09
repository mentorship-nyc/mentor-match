$stdout.puts 'initializers:'

initializers = Dir["lib/initializers/*.rb"]

if initializers.empty?
  puts '- empty'
else
  initializers.sort.each do |file_path|
    require "./#{file_path}"
    $stdout.puts "- loaded #{file_path}"
  end
end
