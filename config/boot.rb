require 'bundler/setup'

Bundler.require(:default)

I18n.enforce_available_locales = false

module CoreLoader
  BASE_PATH = "#{File.expand_path(File.dirname(__FILE__))}/../"

  def self.path(load_path)
    Dir["#{BASE_PATH}/#{load_path}", "#{BASE_PATH}/#{load_path}.rb"].each do |file_path|
      $stdout.puts file_path if ENV['DEBUG']
      require(file_path)
    end
  end
end

CoreLoader.path('lib/*.rb')
CoreLoader.path('app/mailers/*.rb')
CoreLoader.path('app/models/*.rb')
CoreLoader.path('app/routes/*.rb')
CoreLoader.path('initializers/*.rb')
CoreLoader.path('lib/mentor_match/application.rb')
CoreLoader.path('app/helpers/*.rb')
