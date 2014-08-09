require 'active_record'
require 'uri'

db = URI.parse(ENV['DATABASE_URL'])

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

basename = File.basename(__FILE__, '.rb')

$stdout.puts 'established activerecord connection'

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
