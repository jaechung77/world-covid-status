## What is World-Covid-Status CLI App?

World-Covid-Staus CLI App is programmed by Ruby and is to show current status of Covid-19 by country.
It is to scrape data from "https://www.worldometers.info/coronavirus/"

## Scraping HTML Using Nokogiri and Open-URI
It searches the corresponding table from the end point and scrapes table id `main_table_countries_today`

## World-Covid-Status CLI Structure

├── bin
│   ├── console
│   ├── setup
│   └── world-covid-status
├── config
│   └── environment.rb
├── lib
│   ├── world_covid_status
│   │   ├── cli.rb
│   │   ├── country.rb
│   │   ├── world-covid-status
│   │   └── util.rb
│   └── world_covid_status.rb
└── README.md

## How to execute the CLI
Type `ruby bin/world-covid-status` on bash terminal. 

## Breif Summary of Execution Flow
`ruby bin/world-covid-status` initiates Command Line Interface, `cli.rb`.
`cli.rb` calls `scraper.rb`, which scrapes HTML and extracts data we want.
Then `scraper.rb` initializes `country.rb` that holds data and utilizes.  
 
## Error Handling
In `cli.rb`, it handles exception by user's input. It accepts only integer between 1 to 50.  

## Other Useful Information
### Change font color in bash CLI
You can find `def font_color`, which sets font color to yellow, red and blue.






