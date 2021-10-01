class WorldCovidStatus::Country

    attr_accessor :rank, :name, :ttl_cases, :new_cases, :active_cases, :ttl_cases_per_mil, :population
    @@all = []

    def initialize(rank, name, ttl_cases, new_cases, active_cases, ttl_cases_per_mil, population)
            #Basic info: rank: 0, country name: 1, Total cases: 2, New Cases: 3 // 
            #Additional Info: Active Cases: 8, Tot Cases/1M Population 10, Population 14  
            @rank = rank 
            @name  = name
            @ttl_cases  = ttl_cases
            new_cases == "" ? @new_cases = "N/A" :  @new_cases  = new_cases       
            @active_cases  = active_cases
            @ttl_cases_per_mil = ttl_cases_per_mil
            @population = population
            @@all << self
    end

    def self.all
        @@all
    end    

    def self.find(id)
        self.all[id-1]
    end 
    
    def infected_rate
        rate = ((self.ttl_cases.gsub(/[,]/, "").to_f / self.population.gsub(/[,]/, "").to_f) * 100).round(2)
    end    
end    