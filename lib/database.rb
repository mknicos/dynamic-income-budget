require 'rubygems'
require 'bundler/setup'
require 'active_record'

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/../models/*.rb").each{|f| require f}
I18n.enforce_available_locales = false

require 'logger'
require 'yaml'

class Database
  def self.environment= environment
    @@environment = environment
    Database.connect_to_database
  end

  def self.connect_to_database
    connection_details = YAML::load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details[@@environment])
  end
end
