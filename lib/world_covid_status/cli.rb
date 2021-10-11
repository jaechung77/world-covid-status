class WorldCovidStatus::CLI
    @@order_by = ""
    #default range value
    @@range = 10

    def start_menu
        util = WorldCovidStatus::Util
        puts ""
        puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        puts "Welcome to the worst 100 Countries' Covid Status in the World"
        puts "Update may be available. Do you want to update data?"
        puts "Enter " + util.font_color("Y/y to update", "yellow") + " or " +
              util.font_color("N/n to use the existing data", "yellow") + " from our database "
        puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        input = gets.strip.downcase
        if input == "y"
          WorldCovidStatus::Country.drop_table
          puts ""
          puts "Previous Data Deleted"
          puts ""
          puts "Writing New Data.........."
          WorldCovidStatus::Country.create_table
          WorldCovidStatus::Scraper.new.insert_into_table
          puts ""
          puts "Update Completed!!"
        elsif input == "n"
          puts ""
          puts "Using Previous Data..."
          if !WorldCovidStatus::Country.does_table_exist?
            puts util.font_color("Data does not exist.", "yellow")
            puts ""
            puts "Writing New Data.........."
            WorldCovidStatus::Country.create_table
            WorldCovidStatus::Scraper.new.insert_into_table
            puts ""
            puts "Creation Completed!!"
          end
        elsif input == "q"
          puts ""
          puts "Thank you! Have a great day!"
          exit
        else
          puts ""
          puts util.font_color("Your input is not valid.", "yellow")
          self.start_menu
        end
        main_menu
    end

    def main_menu
        util = WorldCovidStatus::Util
        puts ""
        puts "--------------------------------------------------------------"
        puts util.font_color("Main Menu", "blue")
        puts "--------------------------------------------------------------"
        puts "Please choose which aspect you want to see."
        puts "T/t for Total Cases, A/a for Active Cases, P/p for Population"
        puts "You can quit this app at anytime by Q/q."
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
          exit
        else
          puts ""
          puts util.font_color("Your input is not valid.", "yellow")
          self.main_menu
        end
        ranking_range_menu
    end

    def ranking_range_menu
      util = WorldCovidStatus::Util
      puts "--------------------------------------------------------------"
      puts util.font_color("Ranking Range Menu", "blue")
      puts "--------------------------------------------------------------"
      puts "How many rankings you want to see at a time?"
      puts "You can select 1-100."
      puts "You can go back to main menu at anytime by M/m."
      puts "You can quit this app at anytime by Q/q."
      input = gets.strip.downcase
      if input == "m"
        main_menu
      elsif input == "q"
        puts ""
        puts "Thank you! Have a great day!"
        exit
      elsif input.to_i > 0 &&  input.to_i <101
        @@range = input.to_i
        ranking_menu
      else
        puts ""
        puts util.font_color("Your input is not valid.", "yellow")
        self.ranking_range_menu
      end
    end

    def ranking_menu
        util = WorldCovidStatus::Util
        puts ""
        puts "--------------------------------------------------------------"
        puts util.font_color("Ranking Menu", "blue")
        puts "--------------------------------------------------------------"
        puts "From which ranking of countries would you like to see?"
        puts util.font_color("Current selection is order by No. of #{@@order_by}", 'yellow')
        puts "The ranking will be displayed from number you input."
        puts "For example, if you type 13, ranking 13 to #{13+@@range-1 > 101 ? 100: 13+@@range-1} will be displayed."
        puts "You can quit this app at anytime by Q/q."
        input = gets.strip
        check_quit(input)
        input = input.to_i
        check_error(input)
        print_ranking(input)
        country_info_menu
    end

    def country_info_menu
        util = WorldCovidStatus::Util
        puts "--------------------------------------------------------------"
        puts util.font_color("Country Info Menu", "blue")
        puts "--------------------------------------------------------------"
        puts "What country code would you like more information on? Only 1 to 100 will be accepted!"
        puts "You can quit this app at anytime by Q/q."
        puts "You can go back to main menu by M/m."
        input = gets.strip
        check_quit(input)
        check_main(input)
        input = input.to_i
        check_error(input)
        print_country_info(input.to_i)

        puts ""
        puts "Enter M/m to go to main menu or Q/q to quit this app"

        input = gets.strip.downcase
        if input == "m"
          main_menu
        elsif input == "q"
          puts ""
          puts "Thank you! Have a great day!"
          exit
        else
          puts ""
          puts util.font_color("Your input is not valid.", "yellow")
          self.country_info_menu
        end
    end

    def print_ranking(input)
        util = WorldCovidStatus::Util
        puts  ""
        puts  "---------- Countries #{input} - #{input+@@range-1 > 101 ? 100: input+@@range-1} ----------"
        puts  ""
        puts  "Ranking\t\t Country\t     Population\t    TotalCases\t     DailyCases\t   ActiveCases\t    CountryCode"
        WorldCovidStatus::Country.select_rows(input, @@order_by, @@range).each.with_index(input) do |country, index|
          puts  "#{index}\t\t #{util.left_align(util.cut_string(country.name))}\t " \
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

    def print_country_info(input)
        util = WorldCovidStatus::Util
        WorldCovidStatus::Country.find_country(input.to_i).each do |country|
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
        if input < 1 || input > 100
          puts util.font_color("Your input is not valid!!!", 'red')
          if caller_method == "ranking_menu"
            ranking_menu
          elsif caller_method == "country_info_menu"
            country_info_menu
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

    def check_main(input)
        if input.downcase == 'm'
          main_menu
        end
    end
end