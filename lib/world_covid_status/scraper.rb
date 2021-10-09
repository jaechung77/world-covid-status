class WorldCovidStatus::Scraper
    def get_page
        Nokogiri::HTML(open("https://www.worldometers.info/coronavirus/"))
    end

    def scrape_countries
        self.get_page.css("#main_table_countries_today")
    end

    def insert_into_table
        scrape_countries.css('tr').each.with_index do |row, index|
            if index > 8 && index <109
                name  = row.css('td')[1].text.strip
                ttl_cases  = row.css('td')[2].text.strip.delete(',').to_i
                new_cases  = row.css('td')[3].text.strip.delete(',').delete('+').to_i
                active_cases  = row.css('td')[8].text.strip.delete(',').to_i
                ttl_cases_per_mil = row.css('td')[10].text.strip.delete(',').to_i
                population = row.css('td')[14].text.strip.delete(',').to_i
                WorldCovidStatus::Country.create(name, ttl_cases, new_cases, active_cases, ttl_cases_per_mil, population)
            end
        end
    end
end

