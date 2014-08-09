basename = File.basename(__FILE__, '.rb')
$stdout.puts "#{basename}:"

files = Dir["lib/mentor_match/#{basename}/*.rb"]

if files.empty?
  puts '- empty'
else
  files.sort.each do |file_path|
    require "./#{file_path}"
    $stdout.puts "- loaded #{file_path}"
  end
end
