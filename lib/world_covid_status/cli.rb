class WorldCovidStatus::CLI

    def call
        WorldCovidStatus::Scraper.new.make_countries
        puts ""
        puts "Welcome to the worst 50 Countries' Covid Status in the World"
        start
    end

    def start
        util = WorldCovidStatus::Util
        puts ""
        puts "From what ranking of countries would you like to see?"
        puts "The ranking will be displayed starting from the input number."
        puts "For example, if you type 13, ranking 13 to 22 will be displayed."
        puts "You can quit this app by Q/q anytime."
        input = gets.strip
        check_quit(input)
        input = input.to_i
        check_error(input)
        print_countries(input)
        more_info
    end

    def more_info
        puts ""
        puts "What number of country would you like more information on? Only 1 to 50 will be accepted!"
        puts "You can quit this app by Q/q anytime."
        input = gets.strip
        check_quit(input)
        input = input.to_i
        check_error(input)    
        country = WorldCovidStatus::Country.find(input.to_i)

        print_moreinfo(country)

        puts ""
        puts "Would you like to see another country? Enter Y/y or N/n"
    
        input = gets.strip.downcase
        if input == "y"
          start
        elsif input == "n" || input == "q"
          puts ""
          puts "Thank you! Have a great day!"
          exit
        else
          puts ""
          puts "Your input is not valid."
          start
        end
    end   

    #Basic info: rank: 0, country name: 1, Total cases: 2, New Cases: 3 // 
    #Additional Info: Active Cases: 8, Tot Cases/1M Population 10, Population 14      
    def print_countries(input)
        util = WorldCovidStatus::Util
        puts  ""
        puts  "---------- Countries #{input} - #{input+9} ----------"
        puts  ""
        puts  "Ranking\t Country\t TotalCases\t DailyCases\t ActiveCases"
        WorldCovidStatus::Country.all[input-1, 10].each.with_index(input) do |country, index|
          puts  "#{index}\t #{util.left_align(country.name)}\t" \
                "#{util.right_align(country.ttl_cases)}\t #{util.right_align(country.new_cases)}\t" \
                "#{util.right_align(country.active_cases)}"
        end
    end

    def print_moreinfo(country)
      util = WorldCovidStatus::Util
      puts  ""
      puts  "---------------Description--------------"
      puts  "The population of #{country.name} is #{country.population}."
      puts  "Total case number of COVID-19 is #{country.ttl_cases} and current active case number is " \
            "#{util.font_color(country.active_cases, 'blue')} as of #{Date.today}"
      puts  "So far infected rate of #{country.name} is #{util.font_color(country.infected_rate, 'yellow')}%."  
      puts  "Today's new cases are #{util.font_color(country.new_cases, 'red')}."   
      puts  "" 
    end   

    def check_error(input)
      util = WorldCovidStatus::Util 
      caller_method = caller[0][/`([^']*)'/, 1]     
      if input < 1 || input > 51 
        puts util.font_color("Your input is not valid!!!", 'red')
        if caller_method == "start"
          start
        elsif caller_method == "more_info"  
          more_info
        else
          puts ""
          puts "Thank you! Have a great day!"
          exit
        end       
      end  
    end  

    def check_quit(input)
      if input.downcase == 'q'
        puts ""
        puts "Thank you! Have a great day!"
        exit
      end  
    end  
end    