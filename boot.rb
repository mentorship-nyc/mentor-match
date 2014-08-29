require 'bundler/setup'

Bundler.require(:default)

module CoreLoader
  BASE_PATH = File.expand_path(File.dirname(__FILE__))

  def self.path(load_path)
    $stdout.puts load_path if ENV['DEBUG']

    Dir["#{BASE_PATH}/#{load_path}", "#{BASE_PATH}/#{load_path}.rb"].each do |file_path|
      $stdout.puts file_path if ENV['DEBUG']
      require(file_path)
    end
  end
end

CoreLoader.path('lib/*.rb')
CoreLoader.path('app/*/*.rb')
CoreLoader.path('initializers/*.rb')
CoreLoader.path('lib/mentor_match/application')
