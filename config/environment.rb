require 'nokogiri'
require 'open-uri'
require 'sqlite3'
require 'rake'
require 'active_record'

AR_VERSION = false
#AR_VERSION = true

require_relative '../lib/world_covid_status/scraper'
if AR_VERSION
    require_relative '../lib/world_covid_status/country_ar'
    DB = ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        :database => "db/countries.db"
    )
    DBCONN = ActiveRecord::Base.connection
    DBMIGRATION = ActiveRecord::Migration[5.2]
    puts ""
    puts "++++++++++++++++++++++++++++++++++++++++"
    puts "+          THIS IS AR VERSION          +"
    puts "++++++++++++++++++++++++++++++++++++++++"
    puts ""
else
    require_relative '../lib/world_covid_status/country_raw_sql'
    DB = {:conn => SQLite3::Database.new("db/countries.db")}
    puts ""
    puts "++++++++++++++++++++++++++++++++++++++++"
    puts "+       THIS IS RAW SQL VERSION        +"
    puts "++++++++++++++++++++++++++++++++++++++++"
    puts ""
end
require_relative '../lib/world_covid_status/cli'
require_relative '../lib/world_covid_status/util'

