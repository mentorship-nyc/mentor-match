$stdout.puts 'models:'

models = Dir["lib/mentor_match/models/*.rb"]

if models.empty?
  puts '- empty'
else
  models.sort.each do |file_path|
    require "./#{file_path}"
    $stdout.puts "- loaded #{file_path}"
  end
end
