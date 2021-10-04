require 'pry'
require 'nokogiri'
require 'open-uri'
require 'sqlite3'

require_relative '../lib/world_covid_status/scraper'
require_relative '../lib/world_covid_status/country'
require_relative '../lib/world_covid_status/cli'
require_relative '../lib/world_covid_status/util'

DB = {:conn => SQLite3::Database.new("db/countries.db")}