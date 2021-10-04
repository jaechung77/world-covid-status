class WorldCovidStatus::CLI
    @@order_by = ""
    def call
        WorldCovidStatus::Country.create_table
        WorldCovidStatus::Scraper.new.make_countries
        puts ""
        puts "Welcome to the worst 100 Countries' Covid Status in the World"
        user_select
    end

    def user_select
        util = WorldCovidStatus::Util
        puts ""
        puts "Please choose which aspect you want to see."
        puts "T/t for Total Cases, A/a for Active Cases, P/p for Population"
        puts "You can quit this app anytime by Q/q."
        input = gets.strip.downcase
        if input == "t"
          @@order_by = "ttl_cases"
        elsif input == "a" 
          @@order_by = "active_cases"
        elsif input == "p"   
          @@order_by = "population"
        elsif input == "q"
          puts ""
          puts "Thank you! Have a great day!"
          WorldCovidStatus::Country.drop_table
          exit
        else
          puts ""
          puts util.font_color("Your input is not valid.", "yellow")
          self.user_select  
        end
        start
    end  

    def start
        util = WorldCovidStatus::Util
        puts ""
        puts "From which ranking of countries would you like to see?"
        puts util.font_color("Current selection is order by No. of #{@@order_by}", 'yellow')
        puts "The ranking will be displayed starting from the input number."
        puts "For example, if you type 13, 13th country to 22nd country will be displayed."
        puts "You can quit this app anytime by Q/q."
        input = gets.strip
        check_quit(input)
        input = input.to_i
        check_error(input)
        print_countries(input)
        more_info
    end

    def more_info
        util = WorldCovidStatus::Util
        puts ""
        puts "What country code would you like more information on? Only 1 to 100 will be accepted!"
        puts "You can quit this app anytime by Q/q."
        input = gets.strip
        check_quit(input)
        input = input.to_i
        check_error(input)    
        print_moreinfo(input.to_i)

        puts ""
        puts "Would you like to see another ranking or sort by other field? Enter Y/y or N/n"
    
        input = gets.strip.downcase
        if input == "y"
          user_select
        elsif input == "n" || input == "q"
          puts ""
          puts "Thank you! Have a great day!"
          WorldCovidStatus::Country.drop_table
          exit
        else
          puts ""
          puts util.font_color("Your input is not valid.", "yellow")
          start
        end
    end   
   
    def print_countries(input)
        WorldCovidStatus::Country.select_rows(input, @@order_by)
        util = WorldCovidStatus::Util
        puts  ""
        puts  "---------- Countries #{input} - #{input+9} ----------"
        puts  ""
        puts  "Ranking\t\t Country\t Population\t TotalCases\t DailyCases\t ActiveCases\t CountryCode"
        WorldCovidStatus::Country.all.each.with_index(input) do |country, index|
          puts  "#{index}\t\t #{util.left_align(country.name)}\t " \
                "#{@@order_by == "population" ? util.font_color(util.right_align(util.format_number(country.population)), 'yellow')
                : util.right_align(util.format_number(country.population))}\t " \
                "#{@@order_by == "ttl_cases" ? util.font_color(util.right_align(util.format_number(country.ttl_cases)), 'yellow')
                : util.right_align(util.format_number(country.ttl_cases))}\t " \
                "#{util.right_align(util.format_number(country.new_cases))}\t " \
                "#{@@order_by == "active_cases" ? util.font_color(util.right_align(util.format_number(country.active_cases)), 'yellow')
                : util.right_align(util.format_number(country.active_cases))}\t " \
                "#{util.right_align(country.id.to_s)}\t "
        end
    end

    def print_moreinfo(input) 
        WorldCovidStatus::Country.find(input.to_i) 
        util = WorldCovidStatus::Util     
        WorldCovidStatus::Country.found.each do |country| 
        puts  ""
        puts  "---------------Description--------------"
        puts  "The population of #{country.name} is #{util.format_number(country.population)}."
        puts  "Total case number of COVID-19 is #{util.format_number(country.ttl_cases)} and current active case number is " \
              "#{util.font_color(util.format_number(country.active_cases), 'blue')} as of #{Date.today}"
        puts  "So far infected rate of #{country.name} is #{util.font_color(country.infected_rate, 'yellow')}%."  
        puts  "Today's new cases are #{util.font_color(util.format_number(country.new_cases), 'red')}."   
        puts  "" 
        end
    end   

    def check_error(input)
        util = WorldCovidStatus::Util 
        caller_method = caller[0][/`([^']*)'/, 1]     
        if input < 1 || input > 201 
          puts util.font_color("Your input is not valid!!!", 'red')
          if caller_method == "start"
            start
          elsif caller_method == "more_info"  
            more_info
          else
            puts ""
            puts "Thank you! Have a great day!"
            WorldCovidStatus::Country.drop_table
            exit
          end       
        end  
    end  

    def check_quit(input)
        if input.downcase == 'q'
          puts ""
          puts "Thank you! Have a great day!"
          WorldCovidStatus::Country.drop_table
          exit
        end  
    end  
end    