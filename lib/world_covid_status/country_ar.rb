class WorldCovidStatus::Country < ActiveRecord::Base

    def self.create_table
        DBCONN.create_table(:countries) do |t|
            t.text :name
            t.integer :ttl_cases
            t.integer :new_cases
            t.integer :active_cases
            t.integer :ttl_cases_per_mil
            t.integer :population
        end
    end

    def self.drop_table
        DBMIGRATION.drop_table(:countries, if_exists: true)
    end

    def self.does_table_exist?
        DBCONN.table_exists? 'countries'
    end

    def self.insert_into_table(name, ttl_cases, new_cases, active_cases, ttl_cases_per_mil, population)
        if new_cases == ""
            new_cases = 0
        end
        attributes = {
            name: name,
            ttl_cases: ttl_cases,
            new_cases: new_cases,
            active_cases: active_cases,
            ttl_cases_per_mil: ttl_cases_per_mil,
            population: population
        }
        WorldCovidStatus::Country.create(attributes)
    end

    def self.new_from_db(row)
        country = WorldCovidStatus::Country.new
        country.name = row[1]
        country.ttl_cases = row[2]
        country.new_cases = row[3]
        country.active_cases = row[4]
        country.population = row[5]
        country.id = row[0]
        country
    end

    def self.find_country(id)
        result = []
        row = WorldCovidStatus::Country.where("id = ?", id)
        .pluck(
            :id, :name, :ttl_cases, :new_cases,
            :active_cases, :population
        ).map do |row|
            result << self.new_from_db(row)
        end
        result
    end

    def self.select_rows(start_index, order_by, range)
        result = []
        offset = start_index -1
        WorldCovidStatus::Country.order("#{order_by} desc")
        .limit(range).offset(offset).pluck(
            :id, :name, :ttl_cases, :new_cases,
            :active_cases, :population).map do |row|
            result << self.new_from_db(row)
        end
        result
    end

    def infected_rate
        ((self.ttl_cases.to_f / self.population.to_f) * 100).round(2)
    end
end


