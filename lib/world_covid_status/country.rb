class WorldCovidStatus::Country

    attr_accessor :name, :ttl_cases, :new_cases, :active_cases, :ttl_cases_per_mil, :population, :id
    @@all = []
    @@found = []
    def initialize(name, ttl_cases, new_cases, active_cases, ttl_cases_per_mil, population, id=nil)
        @id = id
        @name  = name
        @ttl_cases  = ttl_cases
        new_cases == "" ? @new_cases = 0 :  @new_cases  = new_cases      
        @active_cases  = active_cases
        @ttl_cases_per_mil = ttl_cases_per_mil
        @population = population
    end

    def self.create_table
        sql =   <<-SQL
                CREATE TABLE IF NOT EXISTS countries (
                    id INTEGER PRIMARY KEY,
                    "name" TEXT,
                    ttl_cases INTEGER,
                    new_cases INTEGER,
                    active_cases INTEGER,
                    ttl_cases_per_mil INTEGER,
                    "population" INTEGER
                )
                SQL
        DB[:conn].execute(sql)        
    end  
    
    def self.drop_table
        sql = <<-SQL
              DROP TABLE IF EXISTS countries
              SQL
        DB[:conn].execute(sql)      
    end 

    def save
        # if self.id
        #     self.update
        # else    
            sql =   <<-SQL
                    INSERT INTO countries (
                    "name", ttl_cases, new_cases, active_cases,
                    ttl_cases_per_mil, "population")
                    values (?, ?, ?, ?, ?, ?)
                    SQL
            DB[:conn].execute(sql, self.name, self.ttl_cases, self.new_cases, 
                            self.active_cases, self.ttl_cases_per_mil, self.population) 
            @id = DB[:conn].execute("SELECT last_insert_rowid() FROM countries")[0][0]                       
        # end        
    end    

    def self.create(name, ttl_cases, new_cases, active_cases, ttl_cases_per_mil, population)
        country = self.new(name, ttl_cases, new_cases, active_cases, ttl_cases_per_mil, population)
        country.save
    end    

    def self.new_from_db(row)
        country = self.new(row[1], row[2], row[3], row[4], row[5], row[6], row[0])
        @@all << country
    end 

    def self.found_from_db(row)
        country = self.new(row[1], row[2], row[3], row[4], row[5], row[6], row[0])
        @@found << country
    end
    
    def self.all
        @@all
    end
    
    def self.found
        @@found
    end

    def self.find(id)
        @@found =[]
        sql = <<-SQL
                SELECT *
                FROM countries
                WHERE id = ?
                LIMIT 1
                SQL
        DB[:conn].execute(sql, id).map do |row|
            self.found_from_db(row)
        end.first
    end 

    def self.select_rows(start_index, order_by)
        @@all = []
        offset = start_index -1  
        sql = <<-SQL
                 SELECT *
                 FROM countries
                 ORDER BY #{order_by} DESC
                 LIMIT 10 OFFSET ?
                 SQL
        DB[:conn].execute(sql, offset).map do |row|
           self.new_from_db(row)
        end
    end    

    def infected_rate
        rate = ((self.ttl_cases.to_f / self.population.to_f) * 100).round(2)
    end    
end    