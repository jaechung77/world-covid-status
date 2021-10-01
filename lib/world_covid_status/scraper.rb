class WorldCovidStatus::Scraper
   
    def get_page
        Nokogiri::HTML(open("https://www.worldometers.info/coronavirus/"))
    end 

    def scrape_countries
        self.get_page.css("#main_table_countries_today")
    end
    
    def make_countries
            scrape_countries.css('tr').each.with_index do |row, index|
            #Basic info: rank: 0, country name: 1, Total cases: 2, New Cases: 3 // 
            #Additional Info: Active Cases: 8, Tot Cases/1M Population 10, Population 14  

            if index > 8 && index <59
                rank = row.css('td')[0].text.strip 
                name  = row.css('td')[1].text.strip 
                ttl_cases  = row.css('td')[2].text.strip 
                new_cases  = row.css('td')[3].text.strip 
                active_cases  = row.css('td')[8].text.strip 
                ttl_cases_per_mil = row.css('td')[10].text.strip 
                population = row.css('td')[14].text.strip     
                WorldCovidStatus::Country.new(rank, name, ttl_cases, new_cases, active_cases, ttl_cases_per_mil, population)
            end
        end
    end    
end

