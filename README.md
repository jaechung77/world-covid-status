## What is World-Covid-Status CLI App?

World-Covid-Staus CLI App is programmed by Ruby and is to show current status of Covid-19 by country.
It is to scrape data from "https://www.worldometers.info/coronavirus/"

## Scraping HTML Using Nokogiri and Open-URI
It searches the corresponding table from the end point and scrapes table id `main_table_countries_today`

## World-Covid-Status CLI Structure
```
├── bin
│   └── world-covid-status
├── config
│   └── environment.rb
├── db
│   └── countries.db
├── lib
│   ├── world_covid_status
│   │   ├── cli.rb
│   │   ├── country.rb
│   │   ├── world-covid-status
│   │   └── util.rb
│   └── world_covid_status.rb
└── README.md
```

## How to execute the CLI
Type `ruby bin/world-covid-status` on bash terminal. 

## Features
When the app is running, you can see 10 rows of offset, order by Population, Total cases and Active Cases.
The ranking range is between 1 to 100.
By entering Country Code(the last column), you can see more information of the country. 
You can quit the app at anytime by Q/q input.

## Breif Summary of Execution Flow
`ruby bin/world-covid-status` initiates Command Line Interface, `cli.rb`.
`cli.rb` calls `scraper.rb`, which scrapes HTML and extracts data we want.
Then `scraper.rb` initializes `country.rb` that saves data into database and manipulates.  
 
## Error Handling
In `cli.rb`, it handles exception by user's input.   

## Other Useful Information
### Change font color in bash CLI
You can find `def font_color in util.rb`, which sets font color to yellow, red and blue.

### Check caller function
When you need to check caller method, you can compare caller name with caller[0][/`([^']*)'/, 1]  

### Escape line break in long string
By putting \(back slash) in the end of line, you can escape from line break.
But you have to make sure no whitespace after \.






